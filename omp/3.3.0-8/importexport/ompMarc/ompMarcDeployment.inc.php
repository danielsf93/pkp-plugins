<?php

import('plugins.importexport.ompMarc.lib.pkp.classes.plugins.importexport.PKPImportExportDeployment');

class ompMarcDeployment extends PKPImportExportDeployment2 {
	/**
	 * Constructor
	 * @param $context Context
	 * @param $user User
	 */
	function __construct($context, $user) {
		parent::__construct($context, $user);
	}

	//
	// Deploymenturation items for subclasses to override
	//
	/**
	 * Get the submission node name
	 * @return string
	 */
	function getSubmissionNodeName() {
		return 'monograph';
	}

	/**
	 * Get the submissions node name
	 * @return string
	 */
	function getSubmissionsNodeName() {
		return 'monographs';
	}

	/**
	 * Get the representation node name
	 */
	function getRepresentationNodeName() {
		return 'publication_format';
	}

    function getSchemaFilename() {
		return 'ompMarc.xsd';
	}
}