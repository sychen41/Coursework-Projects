<?php
class Page extends Controller{
    public $view;
    public $subview;
    public $admin_view;
    public $active_tab;
    public $error_message;
    public $warning_message;
    public $success_message;

    public $myUser;

    // This will execute before an action starts
    public function before(){
        $user_id = Session::get('user_id');
        if(isset($user_id) && $user_id != 0){
            $this->setupUser($user_id);
        }
        else{
            $this->setupUser(0);
        }
 
        $this->error_message = '';
        $this->warning_message = '';
        $this->success_message = '';
    }
 
    //This will execute after an action is completed
    public function after(){
 
        //We will find the file path to the view that will 
        //be specified as $subview by the actual controller
        $this->view->subview = Misc::find_file('views',$this->subview);
        $this->view->admin_view = Misc::find_file('views', $this->admin_view);
        $this->view->message_handler = Misc::find_file('views', 'message_handler');
        if(!$this->view->signatures_view){
            $this->view->signatures_view = Misc::find_file('views', 'signatures');
        }
        $this->view->account_settings = Misc::find_file('views', 'account_settings');
        $this->view->home_view = Misc::find_file('views', 'home');
        $this->view->active_tab = $this->active_tab;
        $this->view->error_message = $this->error_message;
        $this->view->warning_message = $this->warning_message;
        $this->view->success_message = $this->success_message;
        if($this->error_message != '' || $this->warning_message != '' || $this->success_message != ''){
            $this->view->has_message = true;   
        }
        else{
            $this->view->has_message = false;
        }

        $this->view->myUser = $this->myUser;

        if($this->admin_view == 'admin_main'){
            $this->view->users = ORM::factory('user')
                    ->order_by('name','asc')->find_all();
        }

        //And now to render the main view
        $this->response->body=$this->view->render();
    }

    /**
     * Simply determine if this user is an admin
     */
    public function isAdmin(){
        if(isset($this->myUser)){
            if($this->myUser->group == 100) {
                return true;
            }
        }

        return false;
    }

    /**
     * Setup some default controller variables depending on user
     */
    public function setupUser($user_id = 0){
        if($user_id == 0){
            $this->myUser = null;
            $this->view = View::get('login');
        }
        else{
            $this->myUser = ORM::factory('user')->where('user_id', $user_id)->find();

            if(!$this->myUser->loaded()){
                $this->view = View::get('login');
            }
            else{
                $this->view = View::get('main');
                $this->admin_view = "";
                if($this->isAdmin()){
                    $this->admin_view = 'admin_main';
                }
                $this->active_tab = 'intro';

                // defaults for a user
                if($this->myUser->pen_thickness == '') $this->myUser->pen_thickness = 1;
            }
        }
        $this->view->subpath = Config::get('core.basepath') . 'web/';
        $this->view->exepath = Config::get('core.basepath');

        $old_user_id = Session::get('old_user_id');
        $this->view->old_user_id = $old_user_id;
    }
}
?>