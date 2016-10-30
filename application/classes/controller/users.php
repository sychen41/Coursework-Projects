<?php
    class Users_Controller extends Page{
 
        public function action_index(){
            if($this->isAdmin()) {
               $this->admin_view = "admin_main";
               $this->view->title = 'Main User List';
               $this->active_tab = 'admin';
            }
            else{
                $this->view->title = 'Welcome';
                $this->active_tab = 'intro';
            }
        }

        public function action_settings(){
            $this->active_tab = 'settings';
            $this->view->title = 'Account Settings';
        }

        public function action_saveaccountsettings(){
            $this->myUser->pen_thickness = $this->request->post('pen_thickness');
            $this->myUser->save();

            Logger_Model::Log("User " . $this->myUser->name . " set a new pen width.");

            $this->success_message = "Settings Saved!";
            $this->action_settings();
        }
 
        public function action_addedit(){
            if(!$this->isAdmin()) { return; }
            $this->active_tab = 'admin';
            $this->view->title='User Administration';
            $this->admin_view = "admin_addedit";
            
            $mode = "add";
            $user_type = "1";  // regular user by default
            if($this->request->get('user_id')){
                //echo $this->request->get('user_id');
                $mode = "edit";
                $this->view->user = ORM::factory('user')
                    ->where('user_id', $this->request->get('user_id'))->find();
                $user_type = $this->view->user->group;
            }
            $this->view->mode = $mode;
            $this->view->user_type = $user_type;
        }
 
        public function action_save(){
            if(!$this->isAdmin()) { return; }
            $user_id = $this->request->post('user_id');
            if(isset($user_id) && $user_id != ""){
                $user = ORM::factory('user')->where('user_id', $user_id)->find();
            }
            else{
                // make sure a user with this username does not exist
                $username = $this->request->post('username');
                $user_test = ORM::factory('user')->where('name', $username)->find();
                if($user_test->loaded()){
                    $this->error_message = "A User with this name already exists, please try again!";
                    $this->action_addedit();
                    return;
                }
                $user = ORM::factory('user');
                $user->name = $username;
                $user->created_on = date('Y-m-d H:i:s');
            }

            $user->email = $this->request->post('email');
            $password = md5($this->request->post('password'));
            if($password != ""){
                $user->password = $password;
            }
            $user->group = $this->request->post('group');
            $user->save();

            Logger_Model::Log("User " . $user->name . " has been saved.");

            $this->success_message = "User Saved!";
            $this->action_index();
        }

        public function action_delete(){
            if(!$this->isAdmin()) { return; }
            DB::query('delete')->table('users')
                ->where('user_id', $this->request->get('user_id'))
                ->execute();

            Logger_Model::Log("Deleted User with ID " . $this->request->get('user_id'));

            $this->success_message = "User has been deleted.";
            $this->action_index();
        }

        public function action_login(){
            if($this->isAdmin()) { 
                $this->action_index();
                return;
            }
            $username = $this->request->post('username');
            $password = md5($this->request->post('password'));
            //$password = md5($this->request->post('password'));

            if($username == ""){
                return;
            }
            
            $user_test = ORM::factory('user')->where('name', $username)->where('password', $password)->find();

            if($user_test->loaded()){
                Session::set('user_id', $user_test->user_id);
                $this->setupUser($user_test->user_id);

                $user_test->last_login = date('Y-m-d H:i:s');
                $user_test->save();

                $this->view->title = 'Introduction';
                $this->active_tab = 'intro';

                Logger_Model::Log("Log in by " . $username . " from " . $_SERVER['REMOTE_ADDR']);
            }
            else{
                $this->view->invalid_login = 'yes';
                Logger_Model::Log("Failed Login Attempt from " . $_SERVER['REMOTE_ADDR'] . "; Username:" . $username);
                return;
            }
        }
 
        public function action_logout(){
            Logger_Model::Log("Log Out");
            Session::set('user_id', 0); // will reset
            $this->setupUser(0);
        }

        public function action_become(){
            $user_id = $this->request->get('user_id');

            Logger_Model::Log("User becomes user_id " . $user_id);

            Session::set('old_user_id', $this->myUser->user_id);

            Session::set('user_id', $user_id);
            $this->setupUser($user_id);
            $this->view->title = 'Introduction';
            $this->active_tab = 'intro';
        }

        public function action_backtome(){
            $user_id = Session::get('old_user_id');
            if(isset($user_id) && $user_id != 0){
                Session::set('old_user_id', 0);
                Session::set('user_id', $user_id);
                $this->setupUser($user_id);
                $this->view->title = 'Introduction';
                $this->active_tab = 'intro';
            }
        }

        public function action_auditlogs(){
            if(!$this->isAdmin()) { return; }
            $this->active_tab = 'admin';
            $this->view->title='Audit Logs';
            $this->admin_view = "audit_logs";
        }

        public function action_auditlog_service(){
            header('Content-Type: application/json');
            $sort_field = 'action_date';
            $sort_dir = 'desc';
            if(isset($_GET['sort'])){
                $sort_field = $_GET['sort'][0]['field'];
                if($sort_field == 'name') $sort_field = 'users.name';
                $sort_dir = $_GET['sort'][0]['dir'];
            }

            $res = DB::query('select')->table('auditlogs')
                ->fields('log_id', 'user_id', 'action_name', 'action_date', 'users.name')
                ->join('users',array('users.user_id','auditlogs.user_id'),'left')
                ->offset($_GET['skip'])
                ->limit($_GET['take'])
                ->order_by($sort_field, $sort_dir)
                ->execute();


            $count = DB::query('count')->table('auditlogs')->execute();

            echo json_encode(array('PageSize' => $count, 'Result' => $res->as_array()));
            exit;
        }

        public function action_review_forAdmin(){
            $this->active_tab = 'admin';
            $this->view->title = 'Review Document';
            $this->admin_view = "admin_review_docu";
            
            if($this->request->get('document_id')){
                $this->view->document = ORM::factory('document')
                    ->where('document_id', $this->request->get('document_id'))->find();
                //echo $this->view->document->title;
            }
        }

        public function action_approve(){
            if(!$this->isAdmin()) { return; }
            $this->active_tab = 'admin';
            $this->view->title = 'Approve Document';
            $this->admin_view = "approve_document";
        }

        public function action_commitApprove(){
            DB::query('update')->table('documents')
                ->data(array('status'=>'approved'))
                ->where('document_id', $this->request->get('document_id'))
                ->execute();

            Logger_Model::Log("Approved Document with document_ID " . $this->request->get('document_id'));

            $this->success_message = "Document has been approved.";
            $this->action_approve();
      }

        
    }
?>