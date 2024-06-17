<?php
// plugins/generic/AbcdSearch/AbcdSearchDAO.inc.php

import('lib.pkp.classes.db.DAO');
import('lib.pkp.classes.db.DAORegistry');

class AbcdSearchDAO extends DAO {

    public function __construct() {
        parent::__construct();
    }

    // Método com função, que deve ser resgatado e passado ao arquivo .tpl via handler.inc.php
    public function obterDados() {
        $result = $this->retrieve(
            // DISTINCT obtem a lista de copyrights evitando repetição
            'SELECT DISTINCT CONVERT(setting_value USING utf8) as setting_value FROM publication_settings WHERE CONVERT(setting_name USING utf8) = ?',
            ['copyrightHolder']
        );

        // Inicializa um array para armazenar os resultados
        $dados = array();

        // Percorre os resultados
        foreach ($result as $row) {
            $settingValue = $row->setting_value; 
            // Remove "Universidade de São Paulo. " da string
            $settingValue = str_replace("Universidade de São Paulo. ", "", $settingValue);

            $dados[] = $settingValue;
        }

        // Ordenar os resultados em ordem alfabética
        sort($dados);

        // Converta para UTF-8
        $dados = array_map(function($value) {
            return mb_convert_encoding($value, 'UTF-8', 'auto');
        }, $dados);

        return $dados;
    }
}
