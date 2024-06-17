<?php

/**
 * @file plugins/blocks/languageToggle/LanguageToggleBlockPlugin.inc.php
 *
 */

import('lib.pkp.classes.plugins.BlockPlugin');

class LanguageToggleBlockPlugin extends BlockPlugin {

	/**
	 * Install default settings on system install.
	 * @return string
	 */
	function getInstallSitePluginSettingsFile() {
		return $this->getPluginPath() . '/settings.xml';
	}

	/**
	 * Install default settings on journal creation.
	 * @return string
	 */
	function getContextSpecificPluginSettingsFile() {
		return $this->getPluginPath() . '/settings.xml';
	}

	/**
	 * Get the display name of this plugin.
	 * @return String
	 */
	function getDisplayName() {
		return __('plugins.block.languageToggle.displayName');
	}

	/**
	 * Get a description of the plugin.
	 */
	function getDescription() {
		return __('plugins.block.languageToggle.description');
	}

	/**
	 * Get the HTML contents for this block.
	 * @param $templateMgr object
	 * @param $request PKPRequest
	 */

	 function getContents($templateMgr, $request = null) {
		if (!defined('SESSION_DISABLE_INIT')) {
			// Check if the method getJournal() exists in $request object
			if (method_exists($request, 'getJournal')) {
				$journal = $request->getJournal();
				if (isset($journal)) {
					$locales = $journal->getSupportedLocaleNames();
				} else {
					$site = $request->getSite();
					$locales = $site->getSupportedLocaleNames();
				}
			} else {
				// Assuming we are in the context of OMP
				$press = $request->getPress();
				if (isset($press)) {
					$locales = $press->getSupportedLocaleNames();
				} else {
					$site = $request->getSite();
					$locales = $site->getSupportedLocaleNames();
				}
	
				if (isset($_SERVER['HTTP_REFERER'])) {
					$templateMgr->assign('languageToggleNoUser', true);
					$templateMgr->assign('referrerUrl', $_SERVER['HTTP_REFERER']);
				} else {
					unset($locales); // Disable; we're not sure what URL to use
				}
			}
		} else {
			// This part might need adjustment depending on how you handle locales in SESSION_DISABLE_INIT case
			$locales = AppLocale::getAllLocales();
			$templateMgr->assign('languageToggleNoUser', true);
		}
	
		if (isset($locales) && count($locales) > 1) {
			$templateMgr->assign('enableLanguageToggle', true);
			$templateMgr->assign('languageToggleLocales', $locales);
			$templateMgr->assign('iconUrl', 'plugins/blocks/languageToggle/locale');
		}
	
		return parent::getContents($templateMgr, $request);
	}
	
}


