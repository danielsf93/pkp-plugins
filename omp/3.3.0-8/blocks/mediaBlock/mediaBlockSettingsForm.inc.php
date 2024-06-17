<?php

import('lib.pkp.classes.form.Form');

class mediaBlockSettingsForm extends Form
{


    public $plugin;

    public function __construct($plugin)
    {
        parent::__construct($plugin->getTemplateResource('settings.tpl'));
        $this->plugin = $plugin;
        $this->addCheck(new FormValidatorPost($this));
        $this->addCheck(new FormValidatorCSRF($this));
    }

    /**
     * Load settings already saved in the database
     *
     * Settings are stored by context, so that each journal or press
     * can have different settings.
     */
    public function initData()
    {
    	$request = Application::get()->getRequest();
	    $context = $request->getContext();
	    $contextId = ($context && $context->getId()) ? $context->getId() : CONTEXT_SITE;
        $this->setData('link01', $this->plugin->getSetting($contextId, 'link01'));
        $this->setData('link02', $this->plugin->getSetting($contextId, 'link02'));
        $this->setData('link03', $this->plugin->getSetting($contextId, 'link03'));

        parent::initData();
    }

    /**
     * Load data that was submitted with the form
     */
    public function readInputData()
    {
        $this->readUserVars(['link01', 'link02', 'link03']);
        parent::readInputData();
    }

	/**
	 * Fetch any additional data needed for your form.
	 *
	 * Data assigned to the form using $this->setData() during the
	 * initData() or readInputData() methods will be passed to the
	 * template.
	 * @param $request
	 * @param null $template
	 * @param bool $display
	 * @return string|null
	 */
    public function fetch($request, $template = null, $display = false)
    {
        $templateMgr = TemplateManager::getManager($request);
        $templateMgr->assign('pluginName', $this->plugin->getName());
        return parent::fetch($request, $template, $display);
    }

	/**
	 * Save the settings
	 * @param mixed ...$functionArgs
	 * @return mixed|null
	 */
    public function execute(...$functionArgs)
    {
	    $request = Application::get()->getRequest();
	    $context = $request->getContext();
	    $contextId = ($context && $context->getId()) ? $context->getId() : CONTEXT_SITE;
        $this->plugin->updateSetting($contextId, 'link01', $this->getData('link01'));
        $this->plugin->updateSetting($contextId, 'link02', $this->getData('link02'));
        $this->plugin->updateSetting($contextId, 'link03', $this->getData('link03'));
        import('classes.notification.NotificationManager');
        $notificationMgr = new NotificationManager();
        $notificationMgr->createTrivialNotification(
            $request->getUser()->getId(),
            NOTIFICATION_TYPE_SUCCESS,
            ['contents' => __('common.changesSaved')]
        );
        return parent::execute();
    }
}

