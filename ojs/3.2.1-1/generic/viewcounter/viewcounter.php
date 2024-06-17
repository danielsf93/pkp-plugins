<?php
//plugins/generic/viewcounter/viewcounter.php
import('lib.pkp.classes.plugins.GenericPlugin');

class viewcounter extends GenericPlugin {
    public function register($category, $path, $mainContextId = NULL) {
        $success = parent::register($category, $path);
            if ($success && $this->getEnabled()) {
               HookRegistry::register('TemplateResource::getFilename', array($this, '_overridePluginTemplates'));
    
            }
        return $success;
    }

  //nome
	public function getDisplayName() {
		return __('plugins.generic.viewcounter.displayName');
	}

	//descrição
	public function getDescription() {
		return __('plugins.generic.viewcounter.description');
	}
	
	/**
	 * Get the name of the settings file to be installed on new context
	 * creation.
	 * @return string
	 */
	function getContextSpecificPluginSettingsFile() {
		return $this->getPluginPath() . '/settings.xml';
	}

	//sobreposição de arquivo da página do artigo
	public function _overridePluginTemplates($hookName, $args) {
		$templatePath = $args[0];
		if ($templatePath === 'templates/frontend/objects/article_details.tpl') {
			$args[0] = 'plugins/generic/viewcounter/templates/frontend/objects/article_details.tpl';
		}
		return false;
	}
}
