<?php
import('lib.pkp.classes.plugins.BlockPlugin');

class youtubeBlock extends BlockPlugin {
	
	function getContextSpecificPluginSettingsFile() {
		return $this->getPluginPath() . '/settings.xml';
	}

	public function register($category, $path, $mainContextId = NULL) {
    $success = parent::register($category, $path);
		if ($success && $this->getEnabled()) {
    }
		return $success;
	}

	public function getDisplayName() {
		return __('Youtube Block');
	}

	public function getDescription() {
		return __('Adiciona um vídeo em formato Block do lado direito da página da revista. Para adicionar o vídeo, apoś instalar clique em configurações.');
	}

  public function isSitePlugin() {
    return true;
  }

	public function getContents($templateMgr, $request = null)
	{
		$context = Application::get()->getRequest()->getContext();
		$contextId = ($context && $context->getId()) ? $context->getId() : CONTEXT_SITE;
		$templateMgr->assign('titulo', $this->getSetting($contextId, 'titulo'));
		$templateMgr->assign('link', $this->getSetting($contextId, 'link'));
		$templateMgr->assign('descricao', $this->getSetting($contextId, 'descricao'));
		$templateMgr->assign('width', $this->getSetting($contextId, 'width'));
		$templateMgr->assign('height', $this->getSetting($contextId, 'height'));

		return parent::getContents($templateMgr, $request);
	}
	
	public function getActions($request, $actionArgs)
	{
		$actions = parent::getActions($request, $actionArgs);
		if (!$this->getEnabled()) {
			return $actions;
		}
		$router = $request->getRouter();
		import('lib.pkp.classes.linkAction.request.AjaxModal');
		$linkAction = new LinkAction(
			'settings',
			new AjaxModal(
				$router->url(
					$request,
					null,
					null,
					'manage',
					null,
					array(
						'verb' => 'settings',
						'plugin' => $this->getName(),
						'category' => 'blocks'
					)
				),
				$this->getDisplayName()
			),
			__('manager.plugins.settings'),
			null
		);
		array_unshift($actions, $linkAction);
		return $actions;
	}

	public function manage($args, $request)
	{
		switch ($request->getUserVar('verb')) {
			case 'settings':
				$this->import('youtubeBlockSettingsForm');
				$form = new youtubeBlockSettingsForm($this);
				if (!$request->getUserVar('save')) {
					$form->initData();
					return new JSONMessage(true, $form->fetch($request));
				}
				$form->readInputData();
				if ($form->validate()) {
					$form->execute();
					return new JSONMessage(true);
				}
		}
		return parent::manage($args, $request);
	}
}
