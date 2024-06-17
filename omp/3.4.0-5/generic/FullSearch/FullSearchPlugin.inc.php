<?php
import('lib.pkp.classes.plugins.GenericPlugin');
import('lib.pkp.plugins.importexport.users.PKPUserImportExportPlugin');
import('plugins.generic.FullSearch.FullSearchDAO');

class FullSearchPlugin extends GenericPlugin {

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
        if ($page === 'Fullsearch') {
            $this->import('FullSearchPluginHandler');
            define('HANDLER_CLASS', 'FullSearchPluginHandler');
            return true;
        }
        return false;
    }

    public function obterDados() {
        //depende diretamente de Fullsearchdao
        $FullSearchDAO = new FullSearchDAO();
    
        try {
            $dados = $FullSearchDAO->obterDados();
    
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
        return __('plugins.generic.fullsearch.displayname');
    }

    function getDescription() {
        return __('plugins.generic.fullsearch.description');
    }
}
