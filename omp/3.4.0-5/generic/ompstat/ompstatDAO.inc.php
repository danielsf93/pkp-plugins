<?php
// plugins/generic/ompstat/ompstatDAO.inc.php
import('lib.pkp.classes.db.DAO');
import('lib.pkp.classes.db.DAORegistry');

class ompstatDAO extends DAO {
    public function __construct() {
        parent::__construct();
    }

    public function getLivrosPublicados() {
        $result = $this->retrieve(
            'SELECT COUNT(*) as total FROM publications WHERE status = 3;'
        );
        foreach ($result as $row) {
            return $row->total;
        }
        return 0; // Retorna 0 se não houver resultados
    }
   
    public function gettotalAcessos() {
        $result = $this->retrieve(
            'SELECT SUM(metric) as total FROM metrics_submission WHERE assoc_type IN (256, 1048585)'
        );
        foreach ($result as $row) {
            return $row->total;
        }
        return 0; // Retorna 0 se não houver resultados
    }

    public function gettotalDownloads() {
        $result = $this->retrieve(
            'SELECT SUM(metric) as total FROM metrics_submission WHERE assoc_type IN (515)'
        );
        foreach ($result as $row) {
            return $row->total;
        }
        return 0; // Retorna 0 se não houver resultados
    }

    public function getseriesPublicadas() {
        $result = $this->retrieve(
            'SELECT COUNT(*) as total FROM series WHERE is_inactive = 0'
        );
        foreach ($result as $row) {
            return $row->total;
        }
        return 0; // Retorna 0 se não houver resultados
    }

    public function gettotalCategorias() {
        $result = $this->retrieve(
            'SELECT COUNT(*) as total FROM categories WHERE context_id = 1'
        );
        foreach ($result as $row) {
            return $row->total;
        }
        return 0; // Retorna 0 se não houver resultados
    }

    public function gettotalUsuarios() {
        $result = $this->retrieve(
            'SELECT COUNT(*) as total FROM users'
        );
        foreach ($result as $row) {
            return $row->total;
        }
        return 0; // Retorna 0 se não houver resultados
    }

    public function totalAutores() {
        /*** A quantidade de autores é obtida pela quantidade de emails utilizados nas publicações. 
        não se utiliza autores da tabela usuários, pois muitos podem estar cadastrados como autores,
        mas podem nunca ter publicado */
        $result = $this->retrieve(
            'SELECT DISTINCT email FROM authors'
        );
        $totalAutores = []; // Lista para armazenar os e-mails únicos
        // Verifica se há resultados e itera para adicionar e-mails à lista
        if ($result) {
            foreach ($result as $row) { // Itera sobre os resultados
                if (isset($row->email)) { // Verifica se a coluna 'email' existe
                    $totalAutores[] = $row->email; // Adiciona o e-mail à lista
                }
            }
        }
        return $totalAutores; // Retorna a lista de e-mails únicos
    }
    
    public function getDownloadsPorMes() {
        // Consulta para obter métricas com assoc_type = 515, agrupadas por data e ordenadas
        $sql = '
            SELECT DATE_FORMAT(date, "%Y-%m") as data, SUM(metric) as total
            FROM metrics_submission
            WHERE assoc_type = 515
            GROUP BY DATE(date)
            ORDER BY data ASC
        ';
        
        $result = $this->retrieve($sql);
    
        $downloadsPorMes = []; // Lista para armazenar os dados
    
        if ($result) {
            foreach ($result as $row) {
                if (isset($row->data, $row->total)) { // Verifica se os campos necessários existem
                    $downloadsPorMes[] = [
                        'data' => $row->data,
                        'total' => (int) $row->total,
                    ];
                }
            }
        }
    
        return $downloadsPorMes; // Retorna a lista de downloads por data
    }
    
    public function getacessosPorMes() {
        $sql = '
            SELECT DATE as mes, SUM(metric) as total
            FROM metrics_submission
            WHERE assoc_type = 1048585
            GROUP BY mes
            ORDER BY mes ASC
        ';
    
        $result = $this->retrieve($sql);
    
        $acessosPorMes = []; // Lista para armazenar os dados
    
        if ($result) {
            foreach ($result as $row) {
                if (isset($row->mes, $row->total)) { // Verifica se os campos necessários existem
                    $acessosPorMes[] = [
                        'mes' => $row->mes, // Meses agrupados
                        'total' => (int) $row->total,
                    ];
                }
            }
        }
    
        return $acessosPorMes; // Retorna a lista de acessos agrupados por mês
    }
    
    public function getTopLivrosMaisAcessados() {
        // Primeiro passo: Soma dos valores de 'metric' para cada 'submission_id'
        $sql = '
            SELECT submission_id, SUM(metric) as total_metric
            FROM metrics_submission
            WHERE assoc_type = 1048585
            GROUP BY submission_id
            ORDER BY total_metric DESC
            LIMIT 10 
        ';
    
        $result = $this->retrieve($sql);
    
        $topLivros = []; // Lista para armazenar os dados do Top 3
    
        if ($result) {
            foreach ($result as $row) {
                if (isset($row->submission_id, $row->total_metric)) {
                    $topLivros[] = [
                        'submission_id' => $row->submission_id,
                        'total_metric' => (int) $row->total_metric,
                    ];
                }
            }
        }
    
        return $topLivros; // Retorna a lista dos Top 3 livros
    }

    public function getLivrosComTitulos($topLivros) {
        // Obtem os 'submission_id' do Top 3
        $submissionIds = array_column($topLivros, 'submission_id');
    
        if (empty($submissionIds)) {
            return []; // Retorna uma lista vazia se não houver resultados
        }
    
        // Consulta para obter os títulos dos livros
        $sql = '
            SELECT publication_id, setting_value AS title
            FROM publication_settings
            WHERE publication_id IN (' . implode(',', $submissionIds) . ')
            AND setting_name = \'title\'
        ';
    
        $result = $this->retrieve($sql);
    
        if ($result) {
            foreach ($result as $row) {
                foreach ($topLivros as &$livro) {
                    if ($livro['submission_id'] == $row->publication_id) {  // Corrigido para usar notação de objeto
                        $livro['title'] = $row->title; // Acessa propriedade como objeto
                    }
                }
            }
        }
    
        return $topLivros; // Retorna a lista dos Top 3 com títulos
    }

    public function getTopAutoresComPublicacoes() {
        // Consulta para obter nomes completos dos autores e contar publicações
        $sql = '
            SELECT 
                CONCAT(givenName.setting_value, " ", familyName.setting_value) AS nome_completo, 
                COUNT(DISTINCT givenName.author_id) AS total_publicacoes
            FROM 
                author_settings AS givenName
            JOIN 
                author_settings AS familyName
            ON 
                givenName.author_id = familyName.author_id
            WHERE 
                givenName.setting_name = "givenName" 
                AND familyName.setting_name = "familyName"
                AND givenName.locale = "pt_BR"
                AND familyName.locale = "pt_BR"
            GROUP BY 
                nome_completo  -- Agrupa pelo nome completo
            ORDER BY 
                total_publicacoes DESC
        ';
        
        $result = $this->retrieve($sql);
    
        $topAutores = [];  // Lista para armazenar a contagem de publicações por autor
        
        if ($result) {
            foreach ($result as $row) {
                if (isset($row->nome_completo, $row->total_publicacoes)) {  // Verifica se os campos existem
                    $topAutores[] = [
                        'nome_completo' => $row->nome_completo,
                        'total_publicacoes' => (int) $row->total_publicacoes
                    ];
                }
            }
        }
        
        return $topAutores;  // Retorna a lista de autores com a contagem de publicações
    }

    public function getUnidadesComMaisPublicacoes() {
        $sql = '
            SELECT setting_value as unidade, COUNT(*) as total_publicacoes
            FROM publication_settings
            WHERE locale = "pt_BR"
            AND setting_name = "copyrightHolder"
            GROUP BY setting_value
            ORDER BY total_publicacoes DESC
            LIMIT 10 
        ';
        
        $result = $this->retrieve($sql);
        $unidades = [];
        
        if ($result) {
            foreach ($result as $row) {
                if (isset($row->unidade, $row->total_publicacoes)) {
                    $unidadeNome = $row->unidade;
                    
                    // Verifica se a unidade começa com "Universidade de São Paulo. "
                    if (strpos($unidadeNome, "Universidade de São Paulo. ") === 0) {
                        // Remove essa parte do início da string
                        $unidadeNome = substr($unidadeNome, strlen("Universidade de São Paulo. "));
                    }
                    
                    $unidades[] = [
                        'unidade' => $unidadeNome,
                        'total_publicacoes' => (int) $row->total_publicacoes,
                    ];
                }
            }
        }
        
        return $unidades; // Retorna a lista de unidades com as contagens
    }
}