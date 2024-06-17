{* plugins/blocks/deepStat/block.tpl *}

<div class="pkp_block block_madeBy">
    <h3>{translate key="plugins.block.deepStat.title"}</h3>

    <b>{$totalRevistas}</b> {translate key="plugins.block.deepStat.journals"}<br>
    <b>{$totalIssues}</b> {translate key="plugins.block.deepStat.issues"}<br>
    <b>{$totalArticles}</b> {translate key="plugins.block.deepStat.articles"}<br>
    <b>{if empty($totalDownloads)}0{else}{$totalDownloads}{/if}</b> {translate key="plugins.block.deepStat.downloads"}<br>
    <b>{if empty($totalAcess)}0{else}{$totalAcess}{/if}</b> {translate key="plugins.block.deepStat.hits"}<br>
</div>
