            <div class="row wrapper border-bottom white-bg page-heading">
                <div class="col-lg-10">
                    <h2>Nuevo lenguaje</h2>
                    <ol class="breadcrumb">
                        <li>
                            <a>Inicio</a>
                        </li>
                        <li>
                            <a>Lenguajes</a>
                        </li>
                        <li class="active">
                            <strong>Nuevo lenguaje</strong>
                        </li>
                    </ol>
                </div>
                <div class="col-lg-2">

                </div>
            </div>
        <div class="wrapper wrapper-content animated fadeInRight">
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox">
                        <div class="ibox-title">
                            <h5>Lenguaje</h5>
                        </div>
                        <div class="ibox-content">
                            <h2>
                                Nuevo Lenguaje
                            </h2>
                            <form id="form" class="wizard-big" action="language/newlanguage" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="<?php echo $this->security->get_csrf_token_name(); ?>" value="<?php echo $this->security->get_csrf_hash(); ?>">
                                <h1>Información del lenguaje</h1>
                                <fieldset>
                                    <h2>Información</h2>                    
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="form-group">
                                                <label>Nombre *</label>
                                                <input id="name" name="name" type="text" class="form-control required">
                                            </div>
                                            <div class="form-group">
                                                <label>Flag *</label>
                                                <input id="flag " name="flag " type="text" class="form-control required">
                                            </div>
                                            <div class="form-group">
                                                <label>Archivos Shield (Opcional)</label>
                                                <input type="file" name="shield" multiple/>
                                            </div>
                                            <div class="form-group">
                                                <label>Archivos Sandbox (Opcional)</label>
                                                <input type="file" name="sandbox" multiple/>
                                            </div>
                                            <div class="form-group">
                                                <label>Script integrador</label>
                                                <input type="file" name="script" multiple/>
                                            </div>
                                        </div>
                                        <div class="col-lg-12">
                                            <div class="text-center">
                                                <button class="btn btn-primary" type="submit">Guardar</button>
                                            </div>
                                        </div>
                                    </div>

                                </fieldset>
                            </form>
                        </div>
                    </div>
                    </div>

                </div>
            </div>
