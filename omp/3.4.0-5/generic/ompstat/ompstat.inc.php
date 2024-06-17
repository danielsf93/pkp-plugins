<?php
//plugins/generic/ompstat/ompstat.inc.php
import('lib.pkp.classes.plugins.GenericPlugin');
import('lib.pkp.plugins.importexport.users.PKPUserImportExportPlugin');
import('plugins.generic.ompstat.ompstatDAO');
class ompstat extends GenericPlugin {
	public function register($category, $path, $mainContextId = null) {
		$success = parent::register($category, $path, $mainContextId);
		if ($success && $this->getEnabled()) {
			HookRegistry::register('LoadHandler', array($this, 'setPageHandler'));
		}

		return $success;
	}

	public function setPageHandler($hookName, $params) {
		$page = $params[0];
		if ($page === 'ompstat') {
			$this->import('ompstatHandler');
			define('HANDLER_CLASS', 'ompstatHandler');
			return true;
		}
		return false;
	}
	
	//variavel sem funcao para passar ao handler e recuperar no tpl
	public $meuTeste = "varivável do arquivo principal";

	public function getDisplayName() {
		return __('plugins.generic.ompstat.displayname');
	}

	public function getDescription() {
		return __('plugins.generic.ompstat.description');
	}
}