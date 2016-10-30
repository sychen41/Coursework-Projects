<?php
    class Documents_Controller extends Page{

      public function action_index(){
          $this->view->title = 'Document List';
          $this->active_tab = 'signatures';
      }
 
      public function action_add(){
          $this->view->title = 'Add New Document';
          $this->active_tab = 'signatures';
          $this->view->signatures_view = Misc::find_file('views', 'add_document');
      }

      public function action_edit(){
          $this->active_tab = 'signatures';
          $this->view->title = 'Edit Document';
          $this->view->signatures_view = Misc::find_file('views', 'edit_document');
            
          if($this->request->get('document_id')){
              $this->view->document = ORM::factory('document')
                  ->where('document_id', $this->request->get('document_id'))->find();
              //echo $this->view->document->title;
          }
      }

      public function action_review(){
          $this->active_tab = 'signatures';
          $this->view->title = 'Review Document';
          $this->view->signatures_view = Misc::find_file('views', 'review_document');
            
          if($this->request->get('document_id')){
              $this->view->document = ORM::factory('document')
                  ->where('document_id', $this->request->get('document_id'))->find();
              //echo $this->view->document->title;
          }
      }


      public function action_delete(){
            DB::query('delete')->table('documents')
                ->where('document_id', $this->request->get('document_id'))
                ->execute();

            Logger_Model::Log("Deleted Document with document_ID " . $this->request->get('document_id'));

            $this->success_message = "Document has been deleted.";
            $this->action_index();
      }

      public function action_save(){
        $doc = ORM::factory('document');
        $doc->user_id = $this->myUser->user_id;
        $doc->title = $this->request->post('title');
        $doc->content = $this->request->post('content');
        $doc->signature = $this->request->post('glyph');
        $doc->date_added = date('Y-m-d H:i:s');
        $doc->status = 'unapporved';
        $doc->save();

        Logger_Model::Log($this->myUser->name . " added a new document " . $doc->title);

        $this->success_message = "Document Saved!";
        $this->action_index();
      }

      public function action_saveEdit(){
        $document_id = $this->request->post('document_id');
        //echo $document_id;
        $doc = ORM::factory('document', $document_id);
        $doc->user_id = $this->myUser->user_id;
        $doc->title = $this->request->post('title');
        $doc->content = $this->request->post('content');
        $doc->signature = $this->request->post('glyph');
        $doc->date_added = date('Y-m-d H:i:s');
        $doc->status = 'unapporved';
        $doc->save();

        Logger_Model::Log($this->myUser->name . " edited a new document " . $doc->title);

        $this->success_message = "Document Saved!";
        $this->action_index();
      }

      public function action_documents_service(){
            header('Content-Type: application/json');
            $sort_field = 'date_added';
            $sort_dir = 'desc';
            if(isset($_GET['sort'])){
                $sort_field = $_GET['sort'][0]['field'];
                if($sort_field == 'name') $sort_field = 'documents.user_id';
                $sort_dir = $_GET['sort'][0]['dir'];
            }

            $uid = $_SESSION['user_id'];
            $res = DB::query('select')->table('documents')
                ->where('user_id', $uid)
                ->fields('document_id', 'title', 'content', 'date_added', 'status', 'users.name')
                ->join('users',array('users.user_id','documents.user_id'),'left')
                ->offset($_GET['skip'])
                ->limit($_GET['take'])
                ->order_by($sort_field, $sort_dir)
                ->execute();


            $count = DB::query('count')->table('documents')->execute();
            
            echo json_encode(array('PageSize' => $count, 'Result' => $res->as_array(), "UserID" => $uid));
            exit;
      }

      public function action_documents_service_forAdmin(){
            header('Content-Type: application/json');
            $sort_field = 'status';
            $sort_dir = 'desc';
            if(isset($_GET['sort'])){
                $sort_field = $_GET['sort'][0]['field'];
                if($sort_field == 'name') $sort_field = 'documents.title';
                $sort_dir = $_GET['sort'][0]['dir'];
            }

            $uid = $_SESSION['user_id'];
            $res = DB::query('select')->table('documents')
                ->fields('document_id', 'title', 'content', 'date_added', 'status', 'users.name')
                ->join('users',array('users.user_id','documents.user_id'),'left')
                ->offset($_GET['skip'])
                ->limit($_GET['take'])
                ->order_by($sort_field, $sort_dir)
                ->execute();


            $count = DB::query('count')->table('documents')->execute();
            
            echo json_encode(array('PageSize' => $count, 'Result' => $res->as_array(), "UserID" => $uid));
            exit;
      }

    }
?>