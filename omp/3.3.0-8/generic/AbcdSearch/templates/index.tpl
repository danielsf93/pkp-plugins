{* plugins/generic/AbcdSearch/templates/index.tpl *}

 {include file="frontend/components/header.tpl" pageTitleTranslated=$title}
 
 <div class="page">
 <h1>{translate key="plugins.generic.abcdsearch.pagetitle"}</h1>

{$obterDados|escape}

{foreach from=$obterDados item=valor}
    <a href="{url page="copyrightSearch" router=$smarty.const.ROUTE_PAGE}/?query={$valor}"target="_blank">{$valor}</a><br><br>
  
{/foreach}

 </div>

 {include file="frontend/components/footer.tpl"}
 