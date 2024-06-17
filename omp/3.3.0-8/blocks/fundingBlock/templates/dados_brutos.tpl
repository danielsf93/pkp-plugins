{* plugins/blocks/fundingBlock/block.tpl *}

<div class="pkp_block block_madeBy">
    {assign var="foundFunders" value=false}

    {if isset($publication) && $publication->getId()|default:false}
        {if $funders.funders|@count > 0}
            <h3>{translate key="plugins.block.fundingBlock.title"}</h3>
            <ul>
                {foreach from=$funders.funders item=funder}
                    {if $funder.submission_id == $publication->getId()|escape}
                        {assign var="foundFunders" value=true}
                        <li>
                            Submission ID: <b>{$funder.submission_id|escape}</b><br>
                            Funder ID: {$funder.funder_id|escape}<br>
                            Setting Value: {$funders.settings[$funder.funder_id]|escape}<br>
                            Funder_award_number: {$funders.awards[$funder.funder_id]|escape}<br>
                            Funder_identification: {$funder.funder_identification|escape}<br>
                            Link: <a href="https://search.crossref.org/funding?q={$funder.funder_identification|replace:'http://dx.doi.org/10.13039/':''|escape}" target="_blank">{$funders.settings[$funder.funder_id]|escape}</a>                        </li>
                    {/if}
                {/foreach}
            </ul>
            {if !$foundFunders}
                <p>{translate key="plugins.block.fundingBlock.nofunding"}</p>
            {/if}
        {else}
            <p>{translate key="plugins.block.fundingBlock.nofunding"}</p>
        {/if}
    {else}
        <p>{translate key="plugins.block.fundingBlock.noid"}</p>
    {/if}
</div>