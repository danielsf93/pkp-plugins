<?php
//ojs 3.4

import('lib.pkp.classes.plugins.GenericPlugin');

class overrideplugin extends GenericPlugin {
    public function register($category, $path, $mainContextId = NULL) {
        $success = parent::register($category, $path);
            if ($success && $this->getEnabled()) {


//Registre o hook (gancho) para em seguida chamar em função


               HookRegistry::register('TemplateResource::getFilename', array($this, '_overridePluginTemplates'));
			 //  HookRegistry::register('TemplateResource::getFilename', array($this, '_overridearticle_summary'));
    
            }
        return $success;
    }

//chame o hook como função
	public function _overridePluginTemplates($hookName, $args) {
		$templatePath = $args[0];

		//substitua o arquivo tpl original pela versão contida no plugin
		if ($templatePath === 'templates/frontend/objects/article_details.tpl') {
			$args[0] = 'plugins/generic/overrideplugin/templates/frontend/objects/article_details.tpl';
		}
		return false;
	}






	public function getDisplayName() {
		return __('plugins.generic.overrideplugin.displayName');
	}

	public function getDescription() {
		return __('plugins.generic.overrideplugin.description');
	}
	
	function getContextSpecificPluginSettingsFile() {
		return $this->getPluginPath() . '/settings.xml';
	}









}
