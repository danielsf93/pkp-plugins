<?php

/**
 * @file plugins/generic/funding/controllers/grid/form/FunderForm.inc.php
 */

import('lib.pkp.classes.form.Form');

class FunderForm extends Form {
	/** @var int Context ID */
	var $contextId;

	/** @var int Submission ID */
	var $submissionId;

	/** @var FundingPlugin */
	var $plugin;

	/**
	 * Constructor
	 * @param $fundingPlugin FundingPlugin
	 * @param $contextId int Context ID
	 * @param $submissionId int Submission ID
	 * @param $funderId int (optional) Funder ID
	 */
	function __construct($fundingPlugin, $contextId, $submissionId, $funderId = null) {
		parent::__construct($fundingPlugin->getTemplateResource('editFunderForm.tpl'));

		$this->contextId = $contextId;
		$this->submissionId = $submissionId;
		$this->funderId = $funderId;
		$this->plugin = $fundingPlugin;

		// Add form checks
		$this->addCheck(new FormValidator($this, 'funderNameIdentification', 'required', 'plugins.generic.funding.funderNameIdentificationRequired'));
		$this->addCheck(new FormValidatorPost($this));
		$this->addCheck(new FormValidatorCSRF($this));

	}

	/**
	 * @copydoc Form::initData()
	 */
	function initData() {
		$this->setData('submissionId', $this->submissionId);
		if ($this->funderId) {
			$funderDao = DAORegistry::getDAO('FunderDAO');
			$funderAwardDao = DAORegistry::getDAO('FunderAwardDAO');

			$funder = $funderDao->getById($this->funderId);
			$this->setData('funderNameIdentification', $funder->getFunderNameIdentification());

			$funderAwards = $funderAwardDao->getFunderAwardNumbersByFunderId($this->funderId);
			$this->setData('funderAwards', implode(';', $funderAwards));
		}
	}

	/**
	 * @copydoc Form::readInputData()
	 */
	function readInputData() {
		$this->readUserVars(array('funderNameIdentification', 'funderAwards', 'subsidiaryOption'));
	}

	/**
	 * @copydoc Form::fetch
	 */
	function fetch($request, $template = null, $display = false) {
		$templateMgr = TemplateManager::getManager();
		$templateMgr->assign('funderId', $this->funderId);
		$templateMgr->assign('submissionId', $this->submissionId);
		$subsidiaryOptions = array('' => __('plugins.generic.funding.funderSubOrganization.select'));
		$templateMgr->assign('subsidiaryOptions', $subsidiaryOptions);
		return parent::fetch($request);
	}

	/**
	 * Save form values into the database
	 */
	function execute(...$functionArgs) {
		$funderId = $this->funderId;
		$funderDao = DAORegistry::getDAO('FunderDAO');
		$funderAwardDao = DAORegistry::getDAO('FunderAwardDAO');

		if ($funderId) {
			// Load and update an existing funder
			$funder = $funderDao->getById($this->funderId, $this->submissionId);
		} else {
			// Create a new
			$funder = $funderDao->newDataObject();
			$funder->setContextId($this->contextId);
			$funder->setSubmissionId($this->submissionId);
		}

		$funderName = '';
		$funderIdentification = '';
		$funderNameIdentification = $this->getData('funderNameIdentification');
		$subOrganizationNameIdentification = $this->getData('subsidiaryOption');
		if ($funderNameIdentification != ''){
			$funderName = trim(preg_replace('/\s*\[.*?\]\s*/ ', '', $funderNameIdentification));
			if (preg_match('/\[(.*?)\]/', $funderNameIdentification, $output)) {
				$funderIdentification = $output[1];
				if ($subOrganizationNameIdentification != ''){
					$funderName = trim(preg_replace('/\s*\[.*?\]\s*/ ', '', $subOrganizationNameIdentification	));
					$doiPrefix = '';
					if (preg_match('/(http:\/\/dx\.doi\.org\/10\.\d{5}\/)(.+)/', $funderIdentification, $output)) {
						$doiPrefix = $output[1];
					}
					if (preg_match('/\[(.*?)\]/', $subOrganizationNameIdentification, $output)) {
						$funderIdentification = $doiPrefix . $output[1];
					}
				}
			}
		}

		$funder->setFunderName($funderName);
		$funder->setFunderIdentification($funderIdentification);

		if ($funderId) {
			$funderDao->updateObject($funder);
			$funderAwardDao->deleteByFunderId($funderId);
		} else {
			$funderId = $funderDao->insertObject($funder);
		}

		$funderAwards = array();
		if (!empty($this->getData('funderAwards'))) {
			$funderAwards = explode(';', $this->getData('funderAwards'));
		}
		foreach ($funderAwards as $funderAwardNumber){
			$funderAward = $funderAwardDao->newDataObject();
			$funderAward->setFunderId($funderId);
			$funderAward->setFunderAwardNumber($funderAwardNumber);
			$funderAwardDao->insertObject($funderAward);
		}
	}
}
