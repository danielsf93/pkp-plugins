<?php

import('lib.pkp.classes.plugins.GenericPlugin');

class relationalDoi extends GenericPlugin {
    public function register($category, $path, $mainContextId = NULL) {
        $success = parent::register($category, $path);
            if ($success && $this->getEnabled()) {
               HookRegistry::register('TemplateResource::getFilename', array($this, '_overridePluginTemplates'));

            }
        return $success;
    }
    public function _overridePluginTemplates($hookName, $args) {
        $templatePath = $args[0];
        if ($templatePath === 'templates/frontend/objects/article_details.tpl') {
            $args[0] = 'plugins/generic/relationalDoi/templates/frontend/objects/article_details.tpl';
        }
        return false;
    }

  /**
   * Provide a name for this plugin
   *
   * The name will appear in the plugins list where editors can
   * enable and disable plugins.
   */
	public function getDisplayName() {
		return __('Relational DOI');
	}

	/**
   * Provide a description for this plugin
   *
   * The description will appear in the plugins list where editors can
   * enable and disable plugins.
   */
	public function getDescription() {
		return __('Este plugin mostra os DOIs de todos os arquivos de um artigo');
	}
}
