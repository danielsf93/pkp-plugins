<?php
import('lib.pkp.classes.plugins.GenericPlugin');
import('lib.pkp.plugins.importexport.users.PKPUserImportExportPlugin');
import('plugins.generic.AbcdSearch.AbcdSearchDAO');

class AbcdSearchPlugin extends GenericPlugin {

    public function register($category, $path, $mainContextId = null) {
        $success = parent::register($category, $path, $mainContextId);
        if ($success && $this->getEnabled()) {
            HookRegistry::register('LoadHandler', array($this, 'setPageHandler'));
        }

        return $success;
    }

    //montando a página
    public function setPageHandler($hookName, $params) {
        $page = $params[0];
        //site.com/editora/$page
        if ($page === 'abcdsearch') {
            $this->import('AbcdSearchPluginHandler');
            define('HANDLER_CLASS', 'AbcdSearchPluginHandler');
            return true;
        }
        return false;
    }

    public function obterDados() {
        //depende diretamente de abcdsearchdao
        $abcdSearchDAO = new AbcdSearchDAO();
    
        try {
            $dados = $abcdSearchDAO->obterDados();
    
            if (count($dados) > 0) {
                return $dados;
            } else {
                return "Nenhum resultado encontrado";
            }
        } catch (Exception $e) {
            return "Erro: " . $e->getMessage();
        }
    }

    function getDisplayName() {
        return __('plugins.generic.abcdsearch.displayName');
    }

    function getDescription() {
        return __('plugins.generic.abcdsearch.description');
    }
}
