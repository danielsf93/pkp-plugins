<?php
// plugins/generic/FullSearch/FullSearchDAO.inc.php

import('lib.pkp.classes.db.DAO');
import('lib.pkp.classes.db.DAORegistry');

class FullSearchDAO extends DAO {

    public function __construct() {
        parent::__construct();
    }

    public function obterDados() {
        $results = $this->retrieve(
            'SELECT ps1.setting_value AS copyrightholder, ps2.setting_value AS title, ps2.publication_id AS publication_id
            FROM publication_settings ps1
            JOIN publication_settings ps2 ON ps1.publication_id = ps2.publication_id
            WHERE ps1.setting_name = "copyrightHolder"
            AND ps2.setting_name = "title"'
        );
    
        $dados = array();
    
        foreach ($results as $row) {
            $copyrightholder = $row->copyrightholder;
            $title = $row->title;
            $publicationId = $row->publication_id;
    
            // Remove "Universidade de São Paulo. " do copyrightholder
            $copyrightholder = str_replace("Universidade de São Paulo. ", "", $copyrightholder);
    
            // Adiciona o título e o ID ao array associado ao copyrightholder
            $dados[$copyrightholder][] = array(
                'title' => $title,
                'publication_id' => $publicationId
            );
        }
    
        return $dados;
    }
    
    
    
}
