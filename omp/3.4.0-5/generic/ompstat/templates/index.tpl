{* //plugins/generic/ompstat/templates/index.tpl *}

{include file="frontend/components/header.tpl" pageTitleTranslated=$title}

<section class="estatisticas_gerais section_dark"{if $journalDescriptionColour} style="background-color: {$journalDescriptionColour|escape};"{/if}>
    <div class="container">
        <header>
            <h1>{translate key="plugins.generic.ompstat.displayname"}</h1>
        </header>

        <ul class="list-unstyled">  <!-- Usando uma lista para melhor organização -->
          
            <li><strong>{translate key="plugins.generic.ompstat.livrosPublicados"}</strong> {$livrosPublicados}</li>
            <li><strong>{translate key="plugins.generic.ompstat.totalAcessos"}</strong> {$totalAcessos}</li>
            <li><strong>{translate key="plugins.generic.ompstat.totalDownloads"}</strong> {$totalDownloads}</li>
            <li><strong>{translate key="plugins.generic.ompstat.seriesPublicadas"}</strong> {$seriesPublicadas}</li>
            <li><strong>{translate key="plugins.generic.ompstat.totalCategorias"}</strong> {$totalCategorias}</li>
            <li><strong>{translate key="plugins.generic.ompstat.totalUsuarios"}</strong> {$totalUsuarios}</li>
            <li><strong>{translate key="plugins.generic.ompstat.totalAutores"}</strong> {count($totalAutores)}</li>  <!-- Retorna direto a contagem -->
          
        </ul>    

        <header>

{* Inclua o script Chart.js, você pode usar um CDN ou local *}
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<section class="Acessos-por-mes">
    <h2>{translate key="plugins.generic.ompstat.getacessosPorMes"}</h2>
    
    <canvas id="acessosPorMesGrafico"></canvas>  <!-- Onde o gráfico será renderizado -->
    
    <script>
    var ctx = document.getElementById("acessosPorMesGrafico").getContext("2d");
    
    // Obtem as datas (agora agrupadas por mês) e os valores dos Acessos
    var labels = [{foreach from=$acessosPorMes item=access}{if !$smarty.foreach.acessosPorMes.first},{/if}"{$access.mes}", {/foreach}];
    var data = [{foreach from=$acessosPorMes item=access}{if !$smarty.foreach.acessosPorMes.first},{/if}{"{$access.total}"}, {/foreach}];
    
    // Cria o gráfico de barras usando Chart.js
    var myChart = new Chart(ctx, {
        type: "bar", // Tipo do gráfico
        data: {
            labels: labels, // Agora usando meses como rótulos
            datasets: [{
                label: "{translate key="plugins.generic.ompstat.getacessosPorMes"}",
                data: data,
                backgroundColor: "rgba(54, 162, 235, 0.2)", // Cor das barras
                borderColor: "rgba(54, 162, 235, 1)", // Cor da borda das barras
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true // Começa a escala do eixo Y no zero
                }
            }
        }
    });
    </script>
</section>


</header>


<section class="downloads-por-mes">
    <h2>{translate key="plugins.generic.ompstat.getDownloadsPorMes"}</h2>
    
    <canvas id="downloadsPorMesGrafico"></canvas>  <!-- Onde o gráfico será renderizado -->
    
    <script>
    var ctx = document.getElementById("downloadsPorMesGrafico").getContext("2d");
    
    // Obtem as datas e os valores dos downloads
    var labels = [{foreach from=$downloadsPorMes item=download}{if !$smarty.foreach.downloadsPorMes.first},{/if}"{$download.data}", {/foreach}];
    var data = [{foreach from=$downloadsPorMes item=download}{if !$smarty.foreach.downloadsPorMes.first},{/if}{"{$download.total}"}, {/foreach}];
    
    // Cria o gráfico de barras usando Chart.js
    var myChart = new Chart(ctx, {
        type: "bar", // Tipo do gráfico
        data: {
            labels: labels,
            datasets: [{
                label: "{translate key="plugins.generic.ompstat.getDownloadsPorMes"}",
                data: data,
                backgroundColor: "rgba(54, 162, 235, 0.2)", // Cor das barras
                borderColor: "rgba(54, 162, 235, 1)", // Cor da borda das barras
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero: true // Começa a escala do eixo Y no zero
                    }
                }]
            }
        }
    });
    </script>
</section>
      
<h2>{translate key="plugins.generic.ompstat.getTopLivrosMaisAcessados"}</h2>

<ol> <!-- Lista ordenada para mostrar os top 10 livros -->
    {foreach from=$topLivros item=livro} <!-- Itera sobre o array -->
        <li>
            {assign var="link" value={url page='catalog' op='book' path=['book' => $livro.submission_id]}}

            <a href="{$link}" target="_blank"> {$livro.title}</a> {translate key="plugins.generic.ompstat.acess"} {$livro.total_metric}
        </li>
    {/foreach}
</ol>

<h2>{translate key="plugins.generic.ompstat.getTopAutoresComPublicacoes"}</h2>

<ol>
    {assign var="counter" value=0} 
    {foreach from=$topAutores item=autor}
        {if $counter < 10} 
            <li>
                <a href="{url page='search' router=$smarty.const.ROUTE_PAGE}/search/search?query={$autor.nome_completo}" target="_blank">
                    {$autor.nome_completo}
                </a> 
                {translate key="plugins.generic.ompstat.have"} {$autor.total_publicacoes} {translate key="plugins.generic.ompstat.pub"}
            </li>
            {assign var="counter" value=$counter + 1} 
        {/if}
    {/foreach}
</ol>

<h2>{translate key="plugins.generic.ompstat.getUnidadesComMaisPublicacoes"}</h2>

<ol>
    {foreach from=$unidadesComMaisPublicacoes item=unidade}
        <li>
            {$unidade.unidade} {translate key="plugins.generic.ompstat.have"} {$unidade.total_publicacoes} {translate key="plugins.generic.ompstat.pub"}
        </li>
    {/foreach}
</ol>

     {**   <p>TESTE: {$meuTeste}</p> *}

    </div>
</section>

{include file="frontend/components/footer.tpl"}