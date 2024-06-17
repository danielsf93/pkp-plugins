<?php
/**
 * @file plugins/blocks/fundingBlock/fundingBlock.inc.php
 */

 import('lib.pkp.classes.plugins.BlockPlugin');

class fundingBlock extends BlockPlugin {
	//variaveis do banco de dados
    private $databaseHost;
    private $databaseName;
    private $databaseUsername;
    private $databasePassword;

	public function getContents($templateMgr, $request = null)
    {
		$configFile = 'config.inc.php';

        if (file_exists($configFile)) {
            $config = parse_ini_file($configFile, true);
            //acesso ao banco de dados
            if (isset($config['database'])) {
                $this->databaseHost = $config['database']['host'];
                $this->databaseName = $config['database']['name'];
                $this->databaseUsername = $config['database']['username'];
                $this->databasePassword = $config['database']['password'];
            }
        }

		// Chama a função para obter o número de revistas.
        $funders = $this->getFunders();
        
        $templateMgr->assign([
        // Variável com texto simples.
        //'madeByText' => 'Estatísticas do portal:',
        // Variável que contém o número de revistas.
        'funders' => $funders, 
        
    ]);
    
    return parent::getContents($templateMgr, $request);
    }

    //função responsável por obter os dados do banco
    public function getFunders()
    {
        try {
            // Cria uma conexão com o banco de dados usando as configurações fornecidas
            $pdo = new PDO("mysql:host={$this->databaseHost};dbname={$this->databaseName}", $this->databaseUsername, $this->databasePassword);
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $pdo->exec("SET NAMES 'utf8'"); // Define a codificação para UTF-8
    
            // Passo 1: Obter funders da tabela 'funders'
            $queryFunders = "SELECT funder_id, submission_id, CONVERT(funder_identification USING utf8) as funder_identification FROM funders";
            $stmtFunders = $pdo->query($queryFunders);
            $funders = $stmtFunders->fetchAll(PDO::FETCH_ASSOC);
    
            // Passo 2: Obter settings da tabela 'funder_settings' usando os funder_ids obtidos anteriormente
            $settings = [];
            foreach ($funders as $funder) {
                $querySettings = "SELECT CONVERT(setting_value USING utf8) as setting_value FROM funder_settings WHERE funder_id = ?";
                $stmtSettings = $pdo->prepare($querySettings);
                $stmtSettings->execute([$funder['funder_id']]);
                $settingValue = $stmtSettings->fetchColumn();
                $settings[$funder['funder_id']] = $settingValue;
            }
    
            // Passo 3: Obter Funder_award_numbers da tabela 'funder_awards' agrupados por 'funder_id'
            $awards = [];
            foreach ($funders as $funder) {
                $queryAwards = "SELECT CONVERT(funder_award_number USING utf8) as funder_award_number FROM funder_awards WHERE funder_id = ?";
                $stmtAwards = $pdo->prepare($queryAwards);
                $stmtAwards->execute([$funder['funder_id']]);
                $awardNumbers = $stmtAwards->fetchAll(PDO::FETCH_COLUMN);
                $awards[$funder['funder_id']] = implode(';', $awardNumbers);
            }
    
            // Retornar um array contendo funders, settings, awards e funder_identifications
            return ['funders' => $funders, 'settings' => $settings, 'awards' => $awards];
    
        } catch (PDOException $e) {
            // Em caso de erro, retorna um array vazio
            return [];
        }
    }
    
//////funcoes obrigatorias do ojs
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

	function getDisplayName() {
		return 'fundingBlock';
	}
    function getDescription() {
		return __('plugins.block.fundingBlock.description');
	}
}


