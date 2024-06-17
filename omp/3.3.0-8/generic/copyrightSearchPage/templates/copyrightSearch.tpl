{include file="frontend/components/header.tpl" pageTitle="navigation.catalog"}

<link rel="stylesheet" href="{$baseurl}/plugins/generic/copyrightSearchPage/css/copyrightSearch.css" type="text/css" />

<div class="page page_catalog">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="navigation.catalog"}
	<h1>{$searchQuery}</h1>

    <div>
    
    <div class="monograph_count cs_search_input" style="display: none;">
    <input type="text" id="searchPattern" value="{$searchQuery|escape}" placeholder="{translate key="plugins.generic.copyrightSearchPage.SearchPlaceholder"}" size=100>
</div>


    

        <div id="monograph_count" class="monograph_count">
            {translate key="catalog.browseTitles" numTitles=$monographs|@count}
        </div>
        {if $monographs[0]->getData('pubState')}
            <div class="cs_select_pubState">
                <span>{"Include in search:"}</span><br>
                <input type="checkbox" id="includeForthcoming" name="includeForthcoming" value=1 autocomplete="off" checked>
                <label for="includeForthcoming">Forthcoming</label><br>
                <input type="checkbox" id="includeSuperseded" name="includeSuperseded" autocomplete="off" value=0>
                <label for="includeSuperseded">Superseded</label><br>
            </div>
         {/if}
    </div>
    
	{* No published titles *}
	{if !$monographs|@count}
		<h2>
			{translate key="catalog.category.heading"}
		</h2>
		<p>{translate key="catalog.noTitles"}</p>
       
	{* Monograph List *}
	{else}
		{if !$heading}
	        {assign var="heading" value="h2"}
        {/if}
        {if !$titleKey}
            {assign var="monographHeading" value=$heading}
        {elseif $heading == 'h2'}
            {assign var="monographHeading" value="h3"}
        {elseif $heading == 'h3'}
            {assign var="monographHeading" value="h4"}
        {else}
            {assign var="monographHeading" value="h5"}
        {/if}

        <div class="cmp_monographs_list">

            {* Optional title *}
            {if $titleKey}
                <{$heading} class="title">
                    {translate key=$titleKey}
                </{$heading}>
            {/if}

            <div id="pagination_top" class="cs_pagination" data-page="1">
            </div>

            <table id="catalog_table" class="cs_catalog_table paginated">
                <thead>
                    <tr>
                        <th data-type="" class="cs_col"></th>
                        <th id="title" data-type="title-asc" class="cs_col">&#8645;&nbsp;{translate key="plugins.generic.copyrightSearchPage.TableColLabelTitle"}</th>
                        <th id="series" data-type="series-asc" class="cs_col">&#8645;&nbsp;{translate key="plugins.generic.copyrightSearchPage.TableColLabelSeries"}</th>
                        <th id="year" data-type="year-asc" class="cs_col_year">&#8645;&nbsp;{translate key="plugins.generic.copyrightSearchPage.TableColLabelYear"}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach name="monographListLoop" from=$monographs item=monograph}
                        <tr>
                            <td>
                        		<a {if $press}href="{url press=$press->getPath() page="catalog" op="book" path=$monograph->getBestId()}"{else}href="{url page="catalog" op="book" path=$monograph->getBestId()}"{/if} class="cover">
                                    <img class="cs_image" loading="lazy"
                                        src="{$monograph->getCurrentPublication()->getLocalizedCoverImageThumbnailUrl($monograph->getData('contextId'))}"
                                        alt="{$coverImage.altText|escape|default:'No alt text provided for this cover image.'}"
                                    >
                                </a>
                            </td>
                            <td>
                                <div class="title">
                                    <a {if $press}href="{url press=$press->getPath() page="catalog" op="book" path=$monograph->getBestId()}"{else}href="{url page="catalog" op="book" path=$monograph->getBestId()}"{/if}>
                                        {if $monograph->getData('pubState')}
                                            {if $monograph->getData('pubState') == $smarty.const.PUB_STATE_FORTHCOMING}
                                                <p id="pubState" style="display: none;">{$smarty.const.PUB_STATE_FORTHCOMING}</p>
                                                <span class="pubState_forthcoming">{$monograph->getData('pubStateLabel')|escape}</span>{$monograph->getLocalizedFullTitle()|regex_replace:"/Forthcoming: |Superseded: /":""|escape}
                                            {elseif $monograph->getData('pubState') == $smarty.const.PUB_STATE_SUPERSEDED}
                                                <p id="pubState" style="display: none;">{$smarty.const.PUB_STATE_SUPERSEDED}</p>
                                                <span class="pubState_superseded">{$monograph->getData('pubStateLabel')|escape}</span>{$monograph->getLocalizedFullTitle()|regex_replace:"/Forthcoming: |Superseded: /":""|escape}
                                            {else}
                                                {$monograph->getLocalizedFullTitle()|regex_replace:"/Forthcoming: |Superseded: /":""|escape}
                                            {/if}                                   
                                        {else}
                                            <strong>{$monograph->getLocalizedFullTitle()|escape}</strong><br> 
                                        {/if}
                                    </a>
                                </div>
                        		<div class="author">
                                    {$monograph->getAuthorOrEditorString()|escape}<br><b>{$monograph->getLocalizedcopyrightHolder()|escape}</b>
                                </div>
                            </td>
                            <td class="cs_col_series">
                       	    	{if $monograph->getData('seriesPath')}
                                    <div class="seriesPosition tooltip" title="{$monograph->getData('seriesTitle')|escape}">
                                        {assign var=pubs value=$monograph->getData('publications')}
                                        <a {if $press}href="{url press=$press->getPath() page="catalog" op="series" path=$monograph->getData('seriesPath')}"{else}href="{url page="catalog" op="series" path=$monograph->getData('seriesPath')}"{/if}>
                                            {$monograph->getData('seriesPath')|escape|upper}
                                        </a>
                                    </div>
                                {/if}
                            </td>
                            <td class="cs_col cs_col_year">
                                {if $monograph->getData('pubState')}
                                    {if $monograph->getData('pubState') != $smarty.const.PUB_STATE_FORTHCOMING}
                                        {$monograph->getDatePublished()|date_format:"Y"}
                                    {/if}
                                {else}
                                    {$monograph->getDatePublished()|date_format:"Y"}
                                {/if}
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
            <div id="pagination_bottom" class="cs_pagination" data-page="1">
                <div class="cs_page_limits">
                    <label for="pagination_bottom" style="display:inline-block; width: 115px; text-align:right;">{"Results per page: "}<br></label>
                    <select id="pageLimits" onchange="updatePages()">
                        {* <option value=2>2</option> dev option *}
                        <option value=5>5</option>
                        <option value=10>10</option>
                        <option value=25 selected>25</option>
                        <option value=50>50</option>
                        <option value=150>150</option>
                    </select>
                </div>
            </div>
        </div>
	{/if}
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
