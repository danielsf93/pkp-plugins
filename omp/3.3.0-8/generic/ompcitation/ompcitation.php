<?php

import('lib.pkp.classes.plugins.GenericPlugin');

class ompcitation extends GenericPlugin {
    public function register($category, $path, $mainContextId = NULL) {
        $success = parent::register($category, $path);
            if ($success && $this->getEnabled()) {
               HookRegistry::register('TemplateResource::getFilename', array($this, '_overridePluginTemplates'));
               
            }
        return $success;
    }

  /**
   * Provide a name for this plugin
   *
   * The name will appear in the plugins list where editors can
   * enable and disable plugins.
   */
	public function getDisplayName() {
		return __('plugins.generic.ompcitation.name');
	}

	/**
   * Provide a description for this plugin
   *
   * The description will appear in the plugins list where editors can
   * enable and disable plugins.
   */
	public function getDescription() {
		return __('plugins.generic.ompcitation.description');
	}
	
	/**
	 * Get the name of the settings file to be installed on new context
	 * creation.
	 * @return string
	 */
	function getContextSpecificPluginSettingsFile() {
		return $this->getPluginPath() . '/settings.xml';
	}

	public function _overridePluginTemplates($hookName, $args) {
        $templatePath = $args[0];
        if ($templatePath === 'templates/frontend/objects/monograph_full.tpl') {
            $args[0] = 'plugins/generic/ompcitation/templates/frontend/objects/monograph_full.tpl';
        }
        return false;
    }





}
