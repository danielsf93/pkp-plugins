<?php
import('lib.pkp.classes.plugins.BlockPlugin');

class logoABCD extends BlockPlugin {
	
	public function register($category, $path, $mainContextId = NULL) {

    $success = parent::register($category, $path);

		if ($success && $this->getEnabled()) {

    }

		return $success;
	}

	public function getDisplayName() {
		return __('LOGO ABCD');
	}

	public function getDescription() {
		return __('Mostra o logo: Desenvolvido pela Agência de Bibliotecas e Coleções Digitais da USP');
	}

  public function isSitePlugin() {
    return true;
  }
}
