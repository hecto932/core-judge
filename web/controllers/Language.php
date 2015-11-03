<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Language extends MY_Controller 
{
	//CONSTRUCT
	public function __construct() 
	{
		parent::__construct();
	}

    public function index()
    {
        //SET TITLE
        $this->layout->set_title('Judge' . $this->layout->title_separator . 'New Language');

        //ADD CSS AND JS HEADER
        $this->layout->add_includes('css', 'assets/css/plugins/dataTables/dataTables.bootstrap.css','header',$prepend_base_url = TRUE);
        $this->layout->add_includes('css', 'assets/css/plugins/dataTables/dataTables.responsive.css','header',$prepend_base_url = TRUE);
        $this->layout->add_includes('css', 'assets/css/plugins/dataTables/dataTables.tableTools.min.css','header',$prepend_base_url = TRUE);

        //ADD JS FOOTER
        $this->layout->add_includes('js', 'assets/js/plugins/dataTables/jquery.dataTables.js', 'footer',$prepend_base_url = TRUE);
        $this->layout->add_includes('js', 'assets/js/plugins/dataTables/dataTables.bootstrap.js', 'footer',$prepend_base_url = TRUE);
        $this->layout->add_includes('js', 'assets/js/plugins/dataTables/dataTables.responsive.js', 'footer',$prepend_base_url = TRUE);
        $this->layout->add_includes('js', 'assets/js/plugins/dataTables/dataTables.tableTools.min.js', 'footer',$prepend_base_url = TRUE);

        //CONF 
        $this->layout->add_includes('js', 'assets/js/conf/admin/role.js', 'footer',$prepend_base_url = TRUE);

        if( isset($_POST['id']) && isset($_POST['role'])) 
        {
            $data['id'] = $this->security->xss_clean(trim($this->input->post('id')));
            $data['role'] = $this->security->xss_clean(trim($this->input->post('role')));

            $data['idFlag'] = ( ( empty($data['id']) ) ? 1 : 0 );
            $data['roleFlag'] = ( ( empty($data['role']) ) ? 1 : 0 );

            if(! $data['idFlag'] || $data['roleFlag'] )
            {           
                echo $this->process->set_role($data);
            }


        }

        //GET PROBLEMS LIST
        $data['users'] = $this->process->get_users();

        //GET ROLE LIST
        $data['role'] = $this->process->get_roles();

        //LOAD VIEW
        $this->layout->view('language/newLanguage',$data);
    }

    //CARGAMOS LOS ADJUNTOS
    public function upload_shield($language_name)
    {
        //SI EXISTEN ADJUNTOS
        if(!empty($_FILES['shield']))
        {
            foreach ($_FILES["shield"]["error"] as $key => $error) 
            {
                if ($error == UPLOAD_ERR_OK) 
                {
                    $tmp_name = $_FILES["shield"]["tmp_name"][$key];
                    $name = $_FILES["shield"]["name"][$key];
                    $type = $_FILES["shield"]["type"][$key];
                    move_uploaded_file($tmp_name, "languages/$language_name/shield/$name");
                    if($type == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
                        $type = 'DOCX';
                    elseif($type == 'application/pdf')
                        $type = 'PDF';
                    elseif($type == 'application/zip')
                        $type = 'ZIP';
                    elseif($type == 'application/vnd.ms-powerpoint')
                        $type = 'PPT';
                    elseif($type == 'application/msword')
                        $type = 'DOC';
                }
                else
                {
                    return $this->codeToMessage($error);
                }
            }
        }
    }

    //CARGAMOS LOS ADJUNTOS
    public function upload_sandbox($language_name)
    {
        //SI EXISTEN ADJUNTOS
        if(!empty($_FILES['shield']))
        {
            foreach ($_FILES["sandbox"]["error"] as $key => $error) 
            {
                if ($error == UPLOAD_ERR_OK) 
                {
                    $tmp_name = $_FILES["sandbox"]["tmp_name"][$key];
                    $name = $_FILES["sandbox"]["name"][$key];
                    $type = $_FILES["sandbox"]["type"][$key];
                    move_uploaded_file($tmp_name, "languages/$language_name/sandbox/$name");
                    if($type == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
                        $type = 'DOCX';
                    elseif($type == 'application/pdf')
                        $type = 'PDF';
                    elseif($type == 'application/zip')
                        $type = 'ZIP';
                    elseif($type == 'application/vnd.ms-powerpoint')
                        $type = 'PPT';
                    elseif($type == 'application/msword')
                        $type = 'DOC';
                }
                else
                {
                    return $this->codeToMessage($error);
                }
            }
        }
    }

    public function upload_script($language_name)
    {
        //SI EXISTEN ADJUNTOS
        if(!empty($_FILES['script']))
        {
            foreach ($_FILES["script"]["error"] as $key => $error) 
            {
                if ($error == UPLOAD_ERR_OK) 
                {
                    $tmp_name = $_FILES["script"]["tmp_name"][$key];
                    $name = $_FILES["script"]["name"][$key];
                    $type = $_FILES["script"]["type"][$key];
                    move_uploaded_file($tmp_name, "languages/$language_name/$name");
                    if($type == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
                        $type = 'DOCX';
                    elseif($type == 'application/pdf')
                        $type = 'PDF';
                    elseif($type == 'application/zip')
                        $type = 'ZIP';
                    elseif($type == 'application/vnd.ms-powerpoint')
                        $type = 'PPT';
                    elseif($type == 'application/msword')
                        $type = 'DOC';
                }
                else
                {
                    return $this->codeToMessage($error);
                }
            }
        }
    }

    public function newlanguage()
    {
        $this->form_validation->set_rules('name', 'Nombre', 'required');
        $this->form_validation->set_rules('name','flag', 'required');

        $this->form_validation->set_message('required', 'Este campo es requerido');

        if($this->form_validation->run())
        {
            // Estructura de la carpeta deseada
            $estructura = './languages/'.$this->input->post('name').'/';

            // Para crear una estructura anidada se debe especificar
            // el parámetro $recursive en mkdir().

            if(!mkdir($estructura, 0777, true))
            {
                die('Fallo al crear las carpetas...');
            }else
            {
                if(!empty($_FILES['shield']))
                {
                    $estructura = './languages/'.$this->input->post('name').'/shield';
                    mkdir($estructura, 0777, true);
                    $this->upload_shield();
                }

                if(!empty($_FILES['sandbox']))
                {
                    $estructura = './languages/'.$this->input->post('name').'/sandbox';
                    mkdir($estructura, 0777, true);
                    $this->upload_sandbox();
                }

                if(!empty($_FILES['script']))
                {
                    $estructura = './languages/'.$this->input->post('name').'/sandbox';
                    mkdir($estructura, 0777, true);
                    $this->upload_script();
                }
            }
        }
        else
        {
            //SET TITLE
            $this->layout->set_title('Judge' . $this->layout->title_separator . 'New Language');

            //ADD CSS AND JS HEADER
            $this->layout->add_includes('css', 'assets/css/plugins/dataTables/dataTables.bootstrap.css','header',$prepend_base_url = TRUE);
            $this->layout->add_includes('css', 'assets/css/plugins/dataTables/dataTables.responsive.css','header',$prepend_base_url = TRUE);
            $this->layout->add_includes('css', 'assets/css/plugins/dataTables/dataTables.tableTools.min.css','header',$prepend_base_url = TRUE);

            //ADD JS FOOTER
            $this->layout->add_includes('js', 'assets/js/plugins/dataTables/jquery.dataTables.js', 'footer',$prepend_base_url = TRUE);
            $this->layout->add_includes('js', 'assets/js/plugins/dataTables/dataTables.bootstrap.js', 'footer',$prepend_base_url = TRUE);
            $this->layout->add_includes('js', 'assets/js/plugins/dataTables/dataTables.responsive.js', 'footer',$prepend_base_url = TRUE);
            $this->layout->add_includes('js', 'assets/js/plugins/dataTables/dataTables.tableTools.min.js', 'footer',$prepend_base_url = TRUE);

            //CONF 
            $this->layout->add_includes('js', 'assets/js/conf/admin/role.js', 'footer',$prepend_base_url = TRUE);

            if( isset($_POST['id']) && isset($_POST['role'])) 
            {
                $data['id'] = $this->security->xss_clean(trim($this->input->post('id')));
                $data['role'] = $this->security->xss_clean(trim($this->input->post('role')));

                $data['idFlag'] = ( ( empty($data['id']) ) ? 1 : 0 );
                $data['roleFlag'] = ( ( empty($data['role']) ) ? 1 : 0 );

                if(! $data['idFlag'] || $data['roleFlag'] )
                {           
                    echo $this->process->set_role($data);
                }


            }

            //GET PROBLEMS LIST
            $data['users'] = $this->process->get_users();

            //GET ROLE LIST
            $data['role'] = $this->process->get_roles();

            //LOAD VIEW
            $this->layout->view('language/newLanguage',$data);
        }
    }

}

