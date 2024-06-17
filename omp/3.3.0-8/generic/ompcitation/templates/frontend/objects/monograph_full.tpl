{**
 * templates/frontend/objects/monograph_full.tpl
 *}
<div class="obj_monograph_full">

	{* Notification that this is an old version *}
	{if $currentPublication->getID() !== $publication->getId()}
		<div class="cmp_notification notice">
			{capture assign="latestVersionUrl"}{url page="catalog" op="book" path=$monograph->getBestId()}{/capture}
			{translate key="submission.outdatedVersion"
				datePublished=$publication->getData('datePublished')|date_format:$dateFormatShort
				urlRecentVersion=$latestVersionUrl|escape
			}
		</div>
	{/if}

	<h1 class="title">
		{$publication->getLocalizedFullTitle()|escape}
	</h1>

	<div class="row">
		<div class="main_entry">

			{* Author list *}
			<div class="item authors">
				<h2 class="pkp_screen_reader">
					{translate key="submission.authors"}
				</h2>

				{assign var="authors" value=$publication->getData('authors')}

				{* Only show editors for edited volumes *}
				{if $monograph->getWorkType() == $smarty.const.WORK_TYPE_EDITED_VOLUME && $editors|@count}
					{assign var="authors" value=$editors}
					{assign var="identifyAsEditors" value=true}
				{/if}

				{* Show short author lists on multiple lines *}
				{if $authors|@count < 5}
					{foreach from=$authors item=author}
						<div class="sub_item">
							<div class="label">

							
								{if $identifyAsEditors}
									{translate key="submission.editorName" editorName=$author->getFullName()|escape}
								{else}
									{$author->getFullName()|escape}
								{/if}
							</div>
							{if $author->getLocalizedAffiliation()}
								<div class="value">
									{$author->getLocalizedAffiliation()|escape}
								</div>
							{/if}
							{if $author->getOrcid()}
								<span class="orcid">
									<a href="{$author->getOrcid()|escape}" target="_blank">
										{$author->getOrcid()|escape}
									</a>
								</span>
							{/if}
						</div>
					{/foreach}

				{* Show long author lists on one line *}
				{else}
					{foreach name="authors" from=$authors item=author}
						{* strip removes excess white-space which creates gaps between separators *}
						{strip}
							{if $author->getLocalizedAffiliation()}
								{if $identifyAsEditors}
									{capture assign="authorName"}<span class="label">{translate key="submission.editorName" editorName=$author->getFullName()|escape}</span>{/capture}
								{else}
									{capture assign="authorName"}<span class="label">{$author->getFullName()|escape}</span>{/capture}
								{/if}
								{capture assign="authorAffiliation"}<span class="value">{$author->getLocalizedAffiliation()|escape}</span>{/capture}
								{translate key="submission.authorWithAffiliation" name=$authorName affiliation=$authorAffiliation}
							{else}
								<span class="label">{$author->getFullName()|escape}</span>
							{/if}
							{if !$smarty.foreach.authors.last}
								{translate key="submission.authorListSeparator"}
							{/if}
						{/strip}
					{/foreach}
				{/if}
			</div>

			{* DOI (requires plugin) *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() != 'doi'}
					{continue}
				{/if}
				{assign var=pubId value=$monograph->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentPress->getId(), $pubId)|escape}
					<div class="item doi">
						<span class="label">
							{translate key="plugins.pubIds.doi.readerDisplayName"}
						</span>
						<span class="value">
							<a href="{$doiUrl}">
								{$doiUrl}
							</a>
						</span>
					</div>
				{/if}
			{/foreach}

			{* Keywords *}
			{if !empty($publication->getLocalizedData('keywords'))}
			<div class="item keywords">
				<h2 class="label">
					{capture assign=translatedKeywords}{translate key="common.keywords"}{/capture}
					{translate key="semicolon" label=$translatedKeywords}
				</h2>
				<span class="value">
					{foreach name="keywords" from=$publication->getLocalizedData('keywords') item=keyword}
						{$keyword|escape}{if !$smarty.foreach.keywords.last}, {/if}
					{/foreach}
				</span>
			</div>
			{/if}

			{* Abstract *}
			<div class="item abstract">
				<h2 class="label">
					{translate key="submission.synopsis"}
				</h2>
				<div class="value">
					{$publication->getLocalizedData('abstract')|strip_unsafe_html}
				</div>
			</div>

			{* Chapters *}
			{if $chapters|@count}
				<div class="item chapters">
					<h2 class="pkp_screen_reader">
						{translate key="submission.chapters"}
					</h2>
					<ul>
						{foreach from=$chapters item=chapter}
							{assign var=chapterId value=$chapter->getId()}
							<li>
								<div class="title">
									{$chapter->getLocalizedTitle()|escape}
									{if $chapter->getLocalizedSubtitle() != ''}
										<div class="subtitle">
											{$chapter->getLocalizedSubtitle()|escape}
										</div>
									{/if}
								</div>
								{assign var=chapterAuthors value=$chapter->getAuthorNamesAsString()}
								{if $authorString != $chapterAuthors}
									<div class="authors">
										{$chapterAuthors|escape}
									</div>
								{/if}

								{* DOI (requires plugin) *}
								{foreach from=$pubIdPlugins item=pubIdPlugin}
									{if $pubIdPlugin->getPubIdType() != 'doi'}
										{continue}
									{/if}
									{assign var=pubId value=$chapter->getStoredPubId($pubIdPlugin->getPubIdType())}
									{if $pubId}
										{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentPress->getId(), $pubId)|escape}
										<div class="doi">{translate key="plugins.pubIds.doi.readerDisplayName"} <a href="{$doiUrl}">{$doiUrl}</a></div>
									{/if}
								{/foreach}

								{* Display any files that are assigned to this chapter *}
								{pluck_files assign="chapterFiles" files=$availableFiles by="chapter" value=$chapterId}
								{if $chapterFiles|@count}
									<div class="files">

										{* Display chapter files sorted by publication format so that they are ordered
										   consistently across all chapters. *}
										{foreach from=$publicationFormats item=format}
											{pluck_files assign="pubFormatFiles" files=$chapterFiles by="publicationFormat" value=$format->getId()}

											{foreach from=$pubFormatFiles item=file}

												{* Use the publication format name in the download link unless a pub format has multiple files *}
												{assign var=useFileName value=false}
												{if $pubFormatFiles|@count > 1}
													{assign var=useFileName value=true}
												{/if}

												{include file="frontend/components/downloadLink.tpl" downloadFile=$file monograph=$monograph publicationFormat=$format currency=$currency useFilename=$useFileName}
											{/foreach}
										{/foreach}
									</div>
								{/if}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}

			{call_hook name="Templates::Catalog::Book::Main"}

			{* Determine if any authors have biographies to display *}
			{assign var="hasBiographies" value=0}
			{foreach from=$publication->getData('authors') item=author}
				{if $author->getLocalizedBiography()}
					{assign var="hasBiographies" value=$hasBiographies+1}
				{/if}
			{/foreach}
			{if $hasBiographies}
				<div class="item author_bios">
					<h2 class="label">
						{if $hasBiographies > 1}
							{translate key="submission.authorBiographies"}
						{else}
							{translate key="submission.authorBiography"}
						{/if}
					</h2>
					{foreach from=$publication->getData('authors') item=author}
						{if $author->getLocalizedBiography()}
							<div class="sub_item">
								<div class="label">
									{if $author->getLocalizedAffiliation()}
										{capture assign="authorName"}{$author->getFullName()|escape}{/capture}
										{capture assign="authorAffiliation"}<span class="affiliation">{$author->getLocalizedAffiliation()|escape}</span>{/capture}
										{translate key="submission.authorWithAffiliation" name=$authorName affiliation=$authorAffiliation}
									{else}
										{$author->getFullName()|escape}
									{/if}
								</div>
								<div class="value">
									{$author->getLocalizedBiography()|strip_unsafe_html}
								</div>
							</div>
						{/if}
					{/foreach}
				</div>
			{/if}
			
			{* References *}
			{if $citations || $publication->getData('citationsRaw')}
				<div class="item references">
					<h2 class="label">
						{translate key="submission.citations"}
					</h2>
					<div class="value">
						{if $citations}
							{foreach from=$citations item=$citation}
								<p>{$citation->getCitationWithLinks()|strip_unsafe_html}</p>
							{/foreach}
						{else}
							{$publication->getData('citationsRaw')|escape|nl2br}
						{/if}
					</div>
				</div>
			{/if}

		</div><!-- .main_entry -->

		<div class="entry_details">

			{* Cover image *}
			<div class="item cover">
				{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
				<img
					src="{$publication->getLocalizedCoverImageThumbnailUrl($monograph->getData('contextId'))}"
					alt="{$coverImage.altText|escape|default:''}"
				>
			</div>

			{* Any non-chapter files and remote resources *}
			{pluck_files assign=nonChapterFiles files=$availableFiles by="chapter" value=0}
			{if $nonChapterFiles|@count || $remotePublicationFormats|@count}
				<div class="item files">
					<h2 class="pkp_screen_reader">
						{translate key="submission.downloads"}
					</h2>
					{foreach from=$publicationFormats item=format}
						{assign var=publicationFormatId value=$format->getId()}

						{* Remote resources *}
						{if $format->getRemoteUrl()}
							{* Only one resource allowed per format, so mimic single-file-download *}
							<div class="pub_format_{$publicationFormatId|escape} pub_format_remote">
								<a href="{$format->getRemoteURL()|escape}" target="_blank" class="remote_resource">
									{$format->getLocalizedName()|escape}
								</a>
							</div>

						{* File downloads *}
						{else}

							{* Only display files that haven't been displayed in a chapter *}
							{pluck_files assign=pubFormatFiles files=$nonChapterFiles by="publicationFormat" value=$format->getId()}

							{* Use a simplified presentation if only one file exists *}
							{if $pubFormatFiles|@count == 1}
								<div class="pub_format_{$publicationFormatId|escape} pub_format_single">
									{foreach from=$pubFormatFiles item=file}
										{include file="frontend/components/downloadLink.tpl" downloadFile=$file monograph=$monograph publication=$publication publicationFormat=$format currency=$currency}
									{/foreach}
								</div>

							{* Use an itemized presentation if multiple files exist *}
							{elseif $pubFormatFiles|@count > 1}
								<div class="pub_format_{$publicationFormatId|escape}">
									<span class="label">
										{$format->getLocalizedName()|escape}
									</span>
									<span class="value">
										<ul>
											{foreach from=$pubFormatFiles item=file}
												<li>
													<span class="name">
														{$file->getLocalizedData('name')|escape}
													</span>
													<span class="link">
														{include file="frontend/components/downloadLink.tpl" downloadFile=$file monograph=$monograph publication=$publication publicationFormat=$format currency=$currency useFilename=true}
													</span>
												</li>
											{/foreach}
										</ul>
									</span><!-- .value -->
								</div>
							{/if}
						{/if}
					{/foreach}{* Publication formats loop *}
				</div>
			{/if}

			{* Publication Date *}
			{if $publication->getData('datePublished')}
				<div class="item date_published">
					<div class="sub_item">
						<h2 class="label">
							{if $publication->getData('datePublished')|date_format:$dateFormatShort > $smarty.now|date_format:$dateFormatShort}
								{translate key="catalog.forthcoming"}
							{else}
								{translate key="catalog.published"}
							{/if}
						</h2>
						<div class="value">
							{* If this is the original version *}
							{if $firstPublication->getID() === $publication->getId()}
								<span>{$firstPublication->getData('datePublished')|date_format:$dateFormatLong}</span>
							{* If this is an updated version *}
							{else}
								<span>{translate key="submission.updatedOn" datePublished=$firstPublication->getData('datePublished')|date_format:$dateFormatLong dateUpdated=$publication->getData('datePublished')|date_format:$dateFormatLong}</span>
							{/if}
						</div>
					</div>
					{if count($monograph->getPublishedPublications()) > 1}
						<div class="sub_item versions">
							<h2 class="label">
								{translate key="submission.versions"}
							</h2>
							<ul class="value">
								{foreach from=array_reverse($monograph->getPublishedPublications()) item=iPublication}
									{capture assign="name"}{translate key="submission.versionIdentity" datePublished=$iPublication->getData('datePublished')|date_format:$dateFormatShort version=$iPublication->getData('version')}{/capture}
									<li>
										{if $iPublication->getId() === $publication->getId()}
											{$name}
										{elseif $iPublication->getId() === $currentPublication->getId()}
											<a href="{url page="catalog" op="book" path=$monograph->getBestId()}">{$name}</a>
										{else}
											<a href="{url page="catalog" op="book" path=$monograph->getBestId()|to_array:"version":$iPublication->getId()}">{$name}</a>
										{/if}
									</li>
								{/foreach}
							</ul>
						</div>
					{/if}
				</div>
			{/if}

			{* Series *}
			{if $series}
				<div class="item series">
					<div class="sub_item">
						<h2 class="label">
							{translate key="series.series"}
						</h2>
						<div class="value">
							<a href="{url page="catalog" op="series" path=$series->getPath()}">
								{$series->getLocalizedFullTitle()|escape}
							</a>
						</div>
					</div>
					{if $series->getOnlineISSN()}
						<div class="sub_item">
							<h3 class="label">{translate key="catalog.manage.series.onlineIssn"}</h3>
							<div class="value">{$series->getOnlineISSN()|escape}</div>
						</div>
					{/if}
					{if $series->getPrintISSN()}
						<div class="sub_item">
							<h3 class="label">{translate key="catalog.manage.series.printIssn"}</h3>
							<div class="value">{$series->getPrintISSN()|escape}</div>
						</div>
					{/if}
				</div>
			{/if}

			{* Categories *}
			{if $categories}
				<div class="item categories">
					<h2 class="label">
						{translate key="catalog.categories"}
					</h2>
					<div class="value">
						<ul>
							{foreach from=$categories item="category"}
								<li>
									<a href="{url op="category" path=$category->getPath()}">
										{$category->getLocalizedTitle()|strip_unsafe_html}
									</a>
								</li>
							{/foreach}
						</ul>
					</div>
				</div>
			{/if}

			
				{**************************** CITAÇÂO"!!!!!!!!!!!!!!!!! ********************************}




				<div class="item citation"> <b>{translate key="plugins.generic.ompcitation.howto"}</b><br> {* ABNT *} <div class="sub_item abnt"> <button id="buttonabnt">ABNT</button>
				<div id="divAbnt" style="display:none;">
				<style>
					#buttonabnt {
					
					font-weight: bold;
					background-color: #ececec;
					color: #076fb1;
					border-radius: 5px;
					border: 100;
					padding: 5px 76px;
					cursor: pointer;
					
					}
				</style>
				<div class="referencia abnt">
				{if $authors|count == 1}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()}.
				{elseif $authors|count == 2}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()}; {$authors[1]->getLocalizedFamilyName()|upper}, {$authors[1]->getLocalizedGivenName()}.
				{elseif $authors|count == 3}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()}; {$authors[1]->getLocalizedFamilyName()|upper}, {$authors[1]->getLocalizedGivenName()}; {$authors[2]->getLocalizedFamilyName()|upper}, {$authors[2]->getLocalizedGivenName()}.
				{elseif $authors|count > 3}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()} et al.
				{/if}
								 
				<b>{$publication->getLocalizedFullTitle()|escape}</b>.
				{$publication->getData('seriesPosition')} {if $series}({$series->getLocalizedFullTitle()}){/if}. 
				{$publication->getLocalizedData('copyrightHolder')}, 
				{$publication->getData('copyrightYear')}. 
				DOI: <a href="{$doiUrl}">{$doiUrl}</a>
				{translate key="plugins.generic.ompcitation.link"}<a href="{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}"> {$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}</a> .
				{translate key="plugins.generic.ompcitation.date"}{$smarty.now|date_format:"%e %B. %Y"}.
				
				
			</div> </div> 
			
			<script>
				const buttonabnt = document.getElementById("buttonabnt");
				const divAbnt = document.getElementById("divAbnt");
				buttonabnt.addEventListener("click", function() {
				if (divAbnt.style.display === "none") {
					divAbnt.style.display = "block";
					buttonabnt.innerHTML = "ABNT";
				} else {
					divAbnt.style.display = "none";
					buttonabnt.innerHTML = "ABNT";
				}
				});
			</script>
		</div> {* APA *} <div class="sub_item apa"> <button id="buttonapa">APA</button>
			<div id="divapa" style="display:none;">
				<style>
					#buttonapa {
					font-weight: bold;
					background-color: #ececec;
					color: #076fb1;
					border-radius: 5px;
					border: 100;
					padding: 5px 84px;
					cursor: pointer;
					}
				</style>
				<div class="referencia apa">
				{if $authors|count == 1}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()}.
				{elseif $authors|count == 2}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()}, & {$authors[1]->getLocalizedFamilyName()}, {$authors[1]->getLocalizedGivenName()}.
				{elseif $authors|count == 3}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()}, {$authors[1]->getLocalizedFamilyName()}, {$authors[1]->getLocalizedGivenName()}, & {$authors[2]->getLocalizedFamilyName()}, {$authors[2]->getLocalizedGivenName()}.
				{elseif $authors|count == 4}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()}; {$authors[1]->getLocalizedFamilyName()}, {$authors[1]->getLocalizedGivenName()}; {$authors[2]->getLocalizedFamilyName()}, {$authors[2]->getLocalizedGivenName()} & {$authors[3]->getLocalizedFamilyName()}, {$authors[3]->getLocalizedGivenName()}.
				{elseif $authors|count == 5}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()}; {$authors[1]->getLocalizedFamilyName()}, {$authors[1]->getLocalizedGivenName()}; {$authors[2]->getLocalizedFamilyName()}, {$authors[2]->getLocalizedGivenName()}; {$authors[3]->getLocalizedFamilyName()}, {$authors[3]->getLocalizedGivenName()} & {$authors[4]->getLocalizedFamilyName()}, {$authors[4]->getLocalizedGivenName()}.
				{elseif $authors|count > 5}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()} et al.
				{/if}
					({$publication->getData('copyrightYear')}). 
					<b>{$publication->getLocalizedFullTitle()|escape}</b>. 
					 {$publication->getData('seriesPosition')}.
					 {$publication->getLocalizedData('copyrightHolder')}.
					 DOI: <a href="{$doiUrl}">{$doiUrl}</a>
					 {translate key="plugins.generic.ompcitation.link"}<a href="{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}"> {$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}</a> .
					 {translate key="plugins.generic.ompcitation.date"}{$smarty.now|date_format:"%e %b. %Y"}.
				</div>
			</div>
			<script>
				const buttonapa = document.getElementById("buttonapa");
				const divapa = document.getElementById("divapa");
				
				buttonapa.addEventListener("click", function() {
				if (divapa.style.display === "none") {
				divapa.style.display = "block";
				buttonapa.innerHTML = "APA";
				} else {
				divapa.style.display = "none";
				buttonapa.innerHTML = "APA";
				}
				});
			</script><br>
		</div> {* ISO *} <div class="sub_item iso"> <button id="buttoniso">ISO</button>
			<div id="diviso" style="display:none;">
				<style>
					#buttoniso {
					font-weight: bold;
					background-color: #ececec;
					color: #076fb1;
					border-radius: 5px;
					border: 100;
					padding: 5px 85px;
					cursor: pointer;
					}
				</style>
				<div class="referencia iso">
				{if $authors|count == 1}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()|substr:0:1}.
				{elseif $authors|count == 2}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()} e {$authors[1]->getLocalizedFamilyName()}, {$authors[1]->getLocalizedGivenName()}.
				{elseif $authors|count == 3}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()}; {$authors[1]->getLocalizedFamilyName()|upper}, {$authors[1]->getLocalizedGivenName()} e {$authors[2]->getLocalizedFamilyName()|upper}, {$authors[2]->getLocalizedGivenName()}.
				{elseif $authors|count > 3}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()} et al.
				{/if}
					<b>{$publication->getLocalizedFullTitle()|escape}</b> 
					{$publication->getData('seriesPosition')} {if $series}({$series->getLocalizedFullTitle()}){/if}.
					{$publication->getLocalizedData('copyrightHolder')}, 
					{$publication->getData('copyrightYear')}.
					DOI: <a href="{$doiUrl}">{$doiUrl}</a>
					[{translate key="plugins.generic.ompcitation.date"}{$smarty.now|date_format:"%e %B. %Y"}.]
					{translate key="plugins.generic.ompcitation.link"}<a href="{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}"> {$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}</a> </p>
				</div>
			</div>
			<script>
				const buttoniso = document.getElementById("buttoniso");
				const diviso = document.getElementById("diviso");
				
				buttoniso.addEventListener("click", function() {
				if (diviso.style.display === "none") {
				diviso.style.display = "block";
				buttoniso.innerHTML = "ISO";
				} else {
				diviso.style.display = "none";
				buttoniso.innerHTML = "ISO";
				}
				});
			</script>
		</div> {* VANCOUVER *} <div class="sub_item vancouver"> <button id="buttonvancouver">Vancouver</button>
			<div id="divvancouver" style="display:none;">
				<style>
					#buttonvancouver {
					font-weight: bold;
					background-color: #ececec;
					color: #076fb1;
					border-radius: 5px;
					border: 100;
					padding: 5px 60px;
					cursor: pointer;
					}
				</style>
				<div class="referencia vancouver">
				{if $authors|count == 1}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()|substr:0:1}.
				{elseif $authors|count == 2}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()}, {$authors[1]->getLocalizedFamilyName()}, {$authors[1]->getLocalizedGivenName()}.
				{elseif $authors|count == 3}
					{$authors[0]->getLocalizedFamilyName()} {$authors[0]->getLocalizedGivenName()|substr:0:1}, {$authors[1]->getLocalizedFamilyName()} {$authors[1]->getLocalizedGivenName()|substr:0:1}, {$authors[2]->getLocalizedFamilyName()} {$authors[2]->getLocalizedGivenName()|substr:0:1}.
				{elseif $authors|count > 3}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()} et al.
				{/if}

				 <b>{$publication->getLocalizedFullTitle()|escape}.</b> 
				 {$publication->getLocalizedData('copyrightHolder')}, 
				 c{$publication->getData('copyrightYear')}. 
				 [{translate key="plugins.generic.ompcitation.vanc"}{$smarty.now|date_format:"%e de %B %Y"}].
				 DOI: <a href="{$doiUrl}">{$doiUrl}</a> 
				 {translate key="plugins.generic.ompcitation.link"}<a href="{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}"> {$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}</a> 
				 
				 </p>
				</div>
			</div>
			<script>
				const buttonvancouver = document.getElementById("buttonvancouver");
				const divvancouver = document.getElementById("divvancouver");
				
				buttonvancouver.addEventListener("click", function() {
				if (divvancouver.style.display === "none") {
				divvancouver.style.display = "block";
				buttonvancouver.innerHTML = "Vancouver";
				} else {
				divvancouver.style.display = "none";
				buttonvancouver.innerHTML = "Vancouver";
				}
				});
			</script>
		</div>

		<div class="marc">  
      
{* Pegar o ISBN *}
        {assign var="isbn" value=""}
        {foreach $publication->getData('publicationFormats') as $publicationFormat}
            {assign var="identificationCodes" value=$publicationFormat->getIdentificationCodes()}
            {while $identificationCode = $identificationCodes->next()}
                {if $identificationCode->getCode() == '02' || $identificationCode->getCode() == '15'}
                    {assign var="isbn" value=$identificationCode->getValue()|replace:"-":""|replace:".":""}
                    {break} {* Encerra o loop ao encontrar o ISBN *}
                {/if}
            {/while}
        {/foreach}
        

{* Organizando a Informação *}

    {assign var="dataFormatada" value=$smarty.now|date_format:"%Y%m%d%H%M%S.0"}
    {assign var="zeroZeroCinco" value="$dataFormatada"}

    {assign var="zeroZeroOito" value="      s2023    bl            000 0 por d"}

    {assign var="zeroDoisZero" value="  a{if $isbn|trim}{$isbn}{else}{/if}7 "}
        
    {assign var="zeroDoisQuatro" value="a{$publication->getStoredPubId('doi')|escape}2DOI"}

    {assign var="zeroQuatroZero" value="  aUSP/ABCD0 "}

    {assign var="zeroQuatroUm" value="apor  "}

    {assign var="zeroQuatroQuatro" value="abl1 "}


     {* Obter Primeiro Autor *}
{assign var="authors" value=$publication->getData('authors')}
{if $authors|@count > 0}
    {assign var="firstAuthor" value=$authors[0]}
    {assign var="givenName" value=$firstAuthor->getLocalizedGivenName()|escape}
    {assign var="surname" value=$firstAuthor->getLocalizedFamilyName()|escape}
    {assign var="orcid" value=$firstAuthor->getOrcid()|default:''}
    {assign var="affiliation" value=$firstAuthor->getLocalizedAffiliation()|default:''}
    {assign var="locale" value=$firstAuthor->getCountryLocalized()|escape}

    {if $affiliation|strstr:'Universidade de São Paulo'}
        {if $orcid}
            {assign var="umZeroZero" value="a{$surname}, {$givenName}0{$orcid}4org5(*)"}
        {else}
            {assign var="umZeroZero" value="a{$surname}, {$givenName}0 4org5(*)"}
        {/if}
    {else}
        {if $orcid && $affiliation}
            {assign var="umZeroZero" value="a{$surname}, {$givenName}0{$orcid}5(*)7INT8{$affiliation}9{$locale}"}
        {elseif $orcid}
            {assign var="umZeroZero" value="a{$surname}, {$givenName}0{$orcid}5(*)7INT9{$locale}"}
        {elseif $affiliation}
            {assign var="umZeroZero" value="a{$surname}, {$givenName}7INT8{$affiliation}9{$locale}"}
        {else}
            {assign var="umZeroZero" value="a{$surname}, {$givenName}5(*)9{$locale}"}
        {/if}
    {/if}
{/if}


{assign var="submissionTitle" value=$publication->getLocalizedFullTitle()}
{assign var="submissionTitleEscaped" value=$submissionTitle|escape:'ENT_QUOTES'}
{assign var="submissionTitleDecoded" value=$submissionTitleEscaped|html_entity_decode}
{assign var="doisQuatroCinco" value="10a{$submissionTitleDecoded}h[recurso eletrônico]  "}




{* Obter Cidade pelo Copyright *}
{assign var="copyrightHolder" value=$publication->getLocalizedData('copyrightHolder')}
{assign var="local" value="LOCAL"} 

{if $copyrightHolder == "Universidade de São Paulo. Escola de Artes, Ciências e Humanidades" || $copyrightHolder == "Universidade de São Paulo. Escola de Artes, Ciências e Humanidades "
|| $copyrightHolder == "Universidade de São Paulo. Escola de Comunicações e Artes" || $copyrightHolder == "Universidade de São Paulo. Escola de Comunicações e Artes "
|| $copyrightHolder == "Universidade de São Paulo. Escola de Educação Física e Esporte" || $copyrightHolder == "Universidade de São Paulo. Escola de Educação Física e Esporte "
|| $copyrightHolder == "Universidade de São Paulo. Escola de Enfermagem" || $copyrightHolder == "Universidade de São Paulo. Escola de Enfermagem "
|| $copyrightHolder == "Universidade de São Paulo. Escola Politécnica" || $copyrightHolder == "Universidade de São Paulo. Escola Politécnica "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Arquitetura e Urbanismo" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Arquitetura e Urbanismo "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Ciências Farmacêuticas" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Ciências Farmacêuticas "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Direito" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Direito "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Economia, Administração e Contabilidade" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Economia, Administração e Contabilidade "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Educação" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Educação "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Filosofia, Letras e Ciências Humanas" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Filosofia, Letras e Ciências Humanas "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Medicina" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Medicina "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Medicina Veterinária e Zootecnia" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Medicina Veterinária e Zootecnia "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Odontologia" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Odontologia "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Saúde Pública" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Saúde Pública "
|| $copyrightHolder == "Universidade de São Paulo. Instituto de Astronomia, Geofísica e Ciências Atmosféricas" || $copyrightHolder == "Universidade de São Paulo. Instituto de Astronomia, Geofísica e Ciências Atmosféricas "
|| $copyrightHolder == "Universidade de São Paulo. Instituto de Biociências" || $copyrightHolder == "Universidade de São Paulo. Instituto de Biociências "
|| $copyrightHolder == "Universidade de São Paulo. Instituto de Ciências Biomédicas" || $copyrightHolder == "Universidade de São Paulo. Instituto de Ciências Biomédicas "
|| $copyrightHolder == "Universidade de São Paulo. Instituto de Energia e Ambiente" || $copyrightHolder == "Universidade de São Paulo. Instituto de Energia e Ambiente "
|| $copyrightHolder == "Universidade de São Paulo. Instituto de Estudos Avançados" || $copyrightHolder == "Universidade de São Paulo. Instituto de Estudos Avançados "
|| $copyrightHolder == "Universidade de São Paulo. Instituto de Estudos Brasileiros" || $copyrightHolder == "Universidade de São Paulo. Instituto de Estudos Brasileiros "
|| $copyrightHolder == "Universidade de São Paulo. Instituto de Física" || $copyrightHolder == "Universidade de São Paulo. Instituto de Física "
|| $copyrightHolder == "Universidade de São Paulo. Instituto de Geociências" || $copyrightHolder == "Universidade de São Paulo. Instituto de Geociências "
|| $copyrightHolder == "Universidade de São Paulo. Instituto de Matemática e Estatística" || $copyrightHolder == "Universidade de São Paulo. Instituto de Matemática e Estatística "
|| $copyrightHolder == "Universidade de São Paulo. Instituto de Medicina Tropical de São Paulo" || $copyrightHolder == "Universidade de São Paulo. Instituto de Medicina Tropical de São Paulo "
|| $copyrightHolder == "Universidade de São Paulo. Instituto de Psicologia" || $copyrightHolder == "Universidade de São Paulo. Instituto de Psicologia "
|| $copyrightHolder == "Universidade de São Paulo. Instituto de Química" || $copyrightHolder == "Universidade de São Paulo. Instituto de Química "
|| $copyrightHolder == "Universidade de São Paulo. Instituto de Relações Internacionais" || $copyrightHolder == "Universidade de São Paulo. Instituto de Relações Internacionais "
|| $copyrightHolder == "Universidade de São Paulo. Instituto Oceanográfico" || $copyrightHolder == "Universidade de São Paulo. Instituto Oceanográfico "
|| $copyrightHolder == "Universidade de São Paulo. Museu de Arqueologia e Etnografia" || $copyrightHolder == "Universidade de São Paulo. Museu de Arqueologia e Etnografia "
|| $copyrightHolder == "Universidade de São Paulo. Museu de Arte Contemporânea" || $copyrightHolder == "Universidade de São Paulo. Museu de Arte Contemporânea "
|| $copyrightHolder == "Universidade de São Paulo. Museu Paulista" || $copyrightHolder == "Universidade de São Paulo. Museu Paulista "
|| $copyrightHolder == "Universidade de São Paulo. Museu de Zoologia" || $copyrightHolder == "Universidade de São Paulo. Museu de Zoologia "
 }
    {assign var="local" value="São Paulo"}

{elseif $copyrightHolder == "Universidade de São Paulo. Faculdade de Odontologia de Bauru" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Odontologia de Bauru "
|| $copyrightHolder == "Universidade de São Paulo. Hospital de Reabilitação de Anomalias Craniofaciais" || $copyrightHolder == "Universidade de São Paulo. Hospital de Reabilitação de Anomalias Craniofaciais "
}
    {assign var="local" value="Bauru"}

{elseif $copyrightHolder == "Universidade de São Paulo. Escola de Engenharia de Lorena" || $copyrightHolder == "Universidade de São Paulo. Escola de Engenharia de Lorena "
}
    {assign var="local" value="Lorena"}

{elseif $copyrightHolder == "Universidade de São Paulo. Centro de Energia Nuclear na Agricultura" || $copyrightHolder == "Universidade de São Paulo. Centro de Energia Nuclear na Agricultura "
|| $copyrightHolder == "Universidade de São Paulo. Escola Superior de Agricultura Luiz de Queiroz" || $copyrightHolder == "Universidade de São Paulo. Escola Superior de Agricultura Luiz de Queiroz "
}
    {assign var="local" value="Piracicaba"}

{elseif $copyrightHolder == "Universidade de São Paulo. Faculdade de Zootecnia e Engenharia de Alimentos" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Zootecnia e Engenharia de Alimentos "
}
    {assign var="local" value="Pirassununga"}

{elseif $copyrightHolder == "Universidade de São Paulo. Escola de Educação Física e Esporte de Ribeirão Preto" || $copyrightHolder == "Universidade de São Paulo. Escola de Educação Física e Esporte de Ribeirão Preto "
|| $copyrightHolder == "Universidade de São Paulo. Escola de Enfermagem de Ribeirão Preto" || $copyrightHolder == "Universidade de São Paulo. Escola de Enfermagem de Ribeirão Preto "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Ciências Farmacêuticas de Ribeirão Preto" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Ciências Farmacêuticas de Ribeirão Preto "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Direito de Ribeirão Preto" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Direito de Ribeirão Preto "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Economia, Administração e Contabilidade de Ribeirão Preto" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Economia, Administração e Contabilidade de Ribeirão Preto "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Filosofia, Ciências e Letras de Ribeirão Preto" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Filosofia, Ciências e Letras de Ribeirão Preto "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Medicina de Ribeirão Preto" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Medicina de Ribeirão Preto "
|| $copyrightHolder == "Universidade de São Paulo. Faculdade de Odontologia de Ribeirão Preto" || $copyrightHolder == "Universidade de São Paulo. Faculdade de Odontologia de Ribeirão Preto "
}
    {assign var="local" value="Ribeirão Preto"}

{elseif $copyrightHolder == "Universidade de São Paulo. Departamento de Engenharia de Minas e Petróleo" || $copyrightHolder == "Universidade de São Paulo. Departamento de Engenharia de Minas e Petróleo "
}
    {assign var="local" value="Santos"}

{elseif $copyrightHolder == "Universidade de São Paulo.  Escola de Engenharia de São Carlos" || $copyrightHolder == "Universidade de São Paulo.  Escola de Engenharia de São Carlos "
|| $copyrightHolder == "Universidade de São Paulo.  Instituto de Arquitetura e Urbanismo" || $copyrightHolder == "Universidade de São Paulo.  Instituto de Arquitetura e Urbanismo "
|| $copyrightHolder == "Universidade de São Paulo.  Instituto de Ciências Matemáticas e de Computação" || $copyrightHolder == "Universidade de São Paulo.  Instituto de Ciências Matemáticas e de Computação "
|| $copyrightHolder == "Universidade de São Paulo.  Instituto de Física de São Carlos" || $copyrightHolder == "Universidade de São Paulo.  Instituto de Física de São Carlos "
|| $copyrightHolder == "Universidade de São Paulo.  Instituto de Química de São Carlos" || $copyrightHolder == "Universidade de São Paulo.  Instituto de Química de São Carlos "
}
    {assign var="local" value="São Carlos"}

{else}
    {assign var="local" value=""}
{/if}

{assign var="holder" value=$publication->getLocalizedData('copyrightHolder')}
{if $holder|strstr:'Universidade de São Paulo. '}
    {assign var="holder" value=$holder|replace:'Universidade de São Paulo. ':''}
{/if}

{assign var="doisMeiaZero" value="a {$local}b{$holder}c{$publication->getData('copyrightYear')}0 "}

{assign var="quatroNoveZero" value=""}
{if $series}
    {assign var="seriesTitle" value=$series->getLocalizedFullTitle()}
    {if $seriesTitle}
        {assign var="quatroNoveZero" value="a {$seriesTitle}"}
    {/if}
{else}
    {assign var="quatroNoveZero" value="a "}
{/if}

{if $publication->getData('seriesPosition')}
    {assign var="quatroNoveZero" value=$quatroNoveZero|cat:"v {$publication->getData('seriesPosition')}"}
{else}
    {assign var="quatroNoveZero" value=$quatroNoveZero|cat:"v "}
{/if}

{assign var="quatroNoveZero" value=$quatroNoveZero|cat:"  "}


    {assign var="cincoZeroZero" value="aDisponível em: https://{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}. Acesso em: {$smarty.now|date_format:"%d.%m.%Y"}"}

{* Demais autores *}
{assign var="additionalAuthors" value=[]}
{foreach $authors as $index => $author}
    {if $index != 0}
        {assign var="additionalAuthors" value=array_merge($additionalAuthors, [$author])}
    {/if}
{/foreach}

{assign var="additionalAuthorsExport" value=""}

{foreach $additionalAuthors as $additionalAuthor}
    {assign var="givenName" value=$additionalAuthor->getLocalizedGivenName()|escape}
    {assign var="surname" value=$additionalAuthor->getLocalizedFamilyName()|escape}
    {assign var="orcid" value=$additionalAuthor->getOrcid()|default:''}
    {assign var="affiliation" value=$additionalAuthor->getLocalizedAffiliation()|default:''}

    {assign var="authorExportString" value="1 a{$surname}, {$givenName}"} 

    {if $orcid}
        {assign var="authorExportString" value="$authorExportString0{$orcid}"}
    {else}
        {assign var="authorExportString" value="$authorExportString0 "} 
    {/if}

    {assign var="authorExportString" value="$authorExportString4org"} 

    {assign var="additionalAuthorsExport" value="$additionalAuthorsExport$authorExportString"} 
{/foreach}
   
    {assign var="oitoCincoMeiaA" value="4 z\"Clicar\" sobre o botão para acesso ao texto completouhttps://doi.org/{$publication->getStoredPubId('doi')|escape}3DOI"}

{foreach from=$publicationFormats item=format}
    {assign var=publicationFormatId value=$format->getId()}
    {pluck_files assign=pubFormatFiles files=$nonChapterFiles by="publicationFormat" value=$format->getId()}
    {if $pubFormatFiles|@count == 1}
      
            {if $publication->getId() === $monograph->getCurrentPublication()->getId()}
                {capture assign=downloadUrl}{url op="view" path=$monograph->getBestId()|to_array:$publicationFormatId:$file->getBestId()}{/capture}
            {else}
                {capture assign=downloadUrl}{url op="view" path=$monograph->getBestId()|to_array:"version":$publication->getId():$publicationFormatId:$file->getBestId()}{/capture}
            {/if}
     {assign var="oitoCincoMeiaB" value="41z\"Clicar\" sobre o botão para acesso ao texto completou{$downloadUrl}3Portal de Livros Abertos da USP  "}
    {/if}
{/foreach}

{assign var="noveQuatroCinco" value="aPbMONOGRAFIA/LIVROc06j2023lNACIONAL"}

{assign var="ldr" value="01131nam 22000241a 4500 "} 

{* Calculando o comprimento da variável $rec005 *}
{assign var="rec005POS" value=0}
{assign var="rec005CAR" value=sprintf('%04d', strlen($zeroZeroCinco) + $rec005POS)}
{assign var="rec005" value="005"|cat:$rec005CAR|cat:sprintf('%05d', $rec005POS)}

{* Calculando o comprimento da variável $rec008 *}
{assign var="rec008POS" value=$rec005CAR + $rec005POS}
{assign var="rec008CAR" value=sprintf('%04d', strlen($zeroZeroOito) + 0)}
{assign var="rec008" value="008"|cat:$rec008CAR|cat:sprintf('%05d', $rec008POS)}

{* Calculando o comprimento da variável $rec020 *}
{assign var="rec020POS" value=$rec008CAR + $rec008POS}
{assign var="rec020CAR" value=sprintf('%04d', strlen($zeroDoisZero) - 3)}
{assign var="rec020" value="020"|cat:$rec020CAR|cat:sprintf('%05d', $rec020POS)}

{* Calculando o comprimento da variável $rec024 *}
{assign var="rec024POS" value=$rec020CAR + $rec020POS}
{assign var="rec024CAR" value=sprintf('%04d', strlen($zeroDoisQuatro) + 3)}
{assign var="rec024" value="024"|cat:$rec024CAR|cat:sprintf('%05d', $rec024POS)}

{* Calculando o comprimento da variável $rec040 *}
{assign var="rec040POS" value=$rec024CAR + $rec024POS}
{assign var="rec040CAR" value=sprintf('%04d', strlen($zeroQuatroZero) - 3)}
{assign var="rec040" value="040"|cat:$rec040CAR|cat:sprintf('%05d', $rec040POS)}

{* Calculando o comprimento da variável $rec041 *}
{assign var="rec041POS" value=$rec040CAR + $rec040POS}
{assign var="rec041CAR" value=sprintf('%04d', strlen($zeroQuatroUm) + 0)}
{assign var="rec041" value="041"|cat:$rec041CAR|cat:sprintf('%05d', $rec041POS)}

{* Calculando o comprimento da variável $rec044 *}
{assign var="rec044POS" value=$rec041CAR + $rec041POS}
{assign var="rec044CAR" value=sprintf('%04d', strlen($zeroQuatroQuatro) + 0)}
{assign var="rec044" value="044"|cat:$rec044CAR|cat:sprintf('%05d', $rec044POS)}

{* Calculando o comprimento da variável $rec100 *}
{assign var="rec100POS" value=$rec044CAR + $rec044POS}
{assign var="rec100CAR" value=sprintf('%04d', strlen($umZeroZero) + 3)}
{assign var="rec100" value="100"|cat:$rec100CAR|cat:sprintf('%05d', $rec100POS)}

{* Calculando o comprimento da variável $rec245 *}
{assign var="rec245POS" value=$rec100CAR + $rec100POS}
{assign var="rec245CAR" value=sprintf('%04d', strlen($doisQuatroCinco) - 3)}
{assign var="rec245" value="245"|cat:$rec245CAR|cat:sprintf('%05d', $rec245POS)}

{assign var="rec260POS" value=$rec245CAR + $rec245POS}
{assign var="rec260CAR" value=sprintf('%04d', strlen($doisMeiaZero) + 0)}
{assign var="rec260" value="260"|cat:$rec260CAR|cat:sprintf('%05d', $rec260POS)}

{assign var="rec490POS" value=$rec260CAR + $rec260POS}
{assign var="rec490CAR" value=sprintf('%04d', strlen($quatroNoveZero) + 3)}
{assign var="rec490" value="490"|cat:$rec490CAR|cat:sprintf('%05d', $rec490POS)}

{assign var="rec500POS" value=$rec490CAR + $rec490POS}
{assign var="rec500CAR" value=sprintf('%04d', strlen($cincoZeroZero) + 3)}
{assign var="rec500" value="500"|cat:$rec500CAR|cat:sprintf('%05d', $rec500POS - 3)}


{assign var="numAutoresAdicionais" value=count($additionalAuthors)}
{assign var="rec700All" value=''} 

{foreach $additionalAuthors as $additionalAuthor}
    {assign var="rec700" value=''} 
    
    {assign var="rec700POS" value=sprintf('%05d', $rec500CAR + $rec500POS)}
    
    {assign var="seteZeroZero" value="1 a{$additionalAuthor->getLocalizedFamilyName()|escape}, {$additionalAuthor->getLocalizedGivenName()|escape}"}

    {if $additionalAuthor->getOrcid()}
        {assign var="seteZeroZero" value="$seteZeroZero0{$additionalAuthor->getOrcid()}"} 
    {else}
        {assign var="seteZeroZero" value="$seteZeroZero0 "} 
    {/if}

    {assign var="seteZeroZero" value="$seteZeroZero4org"}

    {assign var="rec700CAR" value=sprintf('%04d', strlen($seteZeroZero))}

    {assign var="rec700" value=$rec700|cat:"700"|cat:$rec700CAR|cat:$rec700POS - 3|cat:$seteZeroZero|cat:"  "}
    
    {assign var="rec500POS" value=$rec700POS}
    {assign var="rec500CAR" value=$rec700CAR}
    
    {assign var="rec700All" value=$rec700All|cat:$rec700} 
{/foreach}

{assign var="rec700All" value=str_replace(" ", "", $rec700All)}


{assign var="rec856APOS" value=sprintf('%05d', $rec500CAR + $rec500POS)}
{assign var="rec856ACAR" value=sprintf('%04d', strlen($oitoCincoMeiaA) - 1)}

{if $numAutoresAdicionais > 0}
    {assign var="rec856APOS" value=sprintf('%05d', $rec700CAR + $rec700POS)}
    {assign var="rec856ACAR" value=sprintf('%04d', strlen($oitoCincoMeiaA) - 1)}
{/if}

{assign var="rec856A" value="856"|cat:$rec856ACAR|cat:$rec856APOS - 3}

{assign var="rec856BPOS" value=sprintf('%05d', $rec856ACAR + $rec856APOS)}
{assign var="rec856BCAR" value=sprintf('%04d', strlen($oitoCincoMeiaB) - 2)}
{assign var="rec856B" value="856"|cat:$rec856BCAR|cat:$rec856BPOS - 3}

{assign var="rec945POS" value=sprintf('%05d', $rec856BCAR + $rec856BPOS)}
{assign var="rec945CAR" value=sprintf('%04d', strlen($noveQuatroCinco) + 1)}
{assign var="rec945" value="945"|cat:$rec945CAR|cat:$rec945POS - 3}
 
    <button id="downloadButton" class="botao">Baixar Registro MARC</button>
	

<style>
 
    #downloadButton {
		font-weight: bold;
        padding: 5px 18px; /* Espaçamento interno */
        background-color: #ececec; /* Cor de fundo */
        color: #076fb1; /* Cor do texto */
        border: 100; /* Remover borda */
        border-radius: 5px; /* Bordas arredondadas */
        cursor: pointer; /* Cursor ao passar por cima */
    
    }

   
</style>

{assign var="numAutoresAdicionais" value=$additionalAuthors|count}
{assign var="totalautores" value=22000205+($numAutoresAdicionais*12)}
{assign var="totalcaracteres" value=sprintf('%05d', strlen($zeroZeroCinco) + strlen($zeroZeroOito) + strlen($zeroDoisZero) + strlen($zeroDoisQuatro) + strlen($zeroQuatroZero) + strlen($zeroQuatroUm) + strlen($zeroQuatroQuatro) + strlen($umZeroZero) + strlen($doisQuatroCinco) + strlen($doisMeiaZero) + strlen($quatroNoveZero) + strlen($cincoZeroZero) + strlen($additionalAuthorsExport) + strlen($oitoCincoMeiaA) + strlen($oitoCincoMeiaB) + strlen($noveQuatroCinco) + 169)}

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var downloadButton = document.getElementById('downloadButton');
        downloadButton.addEventListener('click', function() {
            var text = "{$totalcaracteres}nam {$totalautores}a 4500 {$rec005|escape:'javascript'}{$rec008|escape:'javascript'}{$rec020|escape:'javascript'}{$rec024|escape:'javascript'}{$rec040|escape:'javascript'}{$rec041|escape:'javascript'}{$rec044|escape:'javascript'}{$rec100|escape:'javascript'}{$rec245|escape:'javascript'}{$rec260|escape:'javascript'}{$rec490|escape:'javascript'}{$rec500|escape:'javascript'}{$rec700All|escape:'javascript'}{$rec856A|escape:'javascript'}{$rec856B|escape:'javascript'}{$rec945|escape:'javascript'}{$zeroZeroCinco|escape:'javascript'}{$zeroZeroOito|escape:'javascript'}{$zeroDoisZero|escape:'javascript'}{$zeroDoisQuatro|escape:'javascript'}{$zeroQuatroZero|escape:'javascript'}{$zeroQuatroUm|escape:'javascript'}{$zeroQuatroQuatro|escape:'javascript'}{$umZeroZero|escape:'javascript'}{$doisQuatroCinco|escape:'javascript'}{$doisMeiaZero|escape:'javascript'}{$quatroNoveZero|escape:'javascript'}{$cincoZeroZero|escape:'javascript'}{$additionalAuthorsExport|escape:'javascript'}{$oitoCincoMeiaA|escape:'javascript'}{$oitoCincoMeiaB|escape:'javascript'}{$noveQuatroCinco|escape:'javascript'}";
            var fileName = 'omp.mrc'; // Nome do arquivo a ser baixado

            var blob = new Blob([text], { type: 'text/plain' });
            if (window.navigator.msSaveOrOpenBlob) {
                window.navigator.msSaveBlob(blob, fileName);
            } else {
                var elem = window.document.createElement('a');
                elem.href = window.URL.createObjectURL(blob);
                elem.download = fileName;
                document.body.appendChild(elem);
                elem.click();
                document.body.removeChild(elem);
            }
        });
    });
</script>
</div>


		</div>
				{**************************** FINAL de CITAÇÂO"!!!!!!!!!!!!!!!!! ********************************}

    
{* Copyright statement *}
			{if $publication->getData('copyrightYear') && $publication->getLocalizedData('copyrightHolder')}
				<div class="item copyright">
					{translate|escape key="submission.copyrightStatement" copyrightYear=$publication->getData('copyrightYear') copyrightHolder=$publication->getLocalizedData('copyrightHolder')}
				</div>
			{/if}

			{* License *}
			{if $publication->getData('licenseUrl')}
				<div class="item license">
					<h2 class="label">
						{translate key="submission.license"}
					</h2>
					{if $ccLicenseBadge}
						{$ccLicenseBadge}
					{else}
						<a href="{$publication->getData('licenseUrl')|escape}">
							{translate key="submission.license"}
						</a>
					{/if}
				</div>
			{/if}

			{* Publication formats *}
			{if count($publicationFormats)}
				{foreach from=$publicationFormats item="publicationFormat"}
					{if $publicationFormat->getIsApproved()}

						{assign var=identificationCodes value=$publicationFormat->getIdentificationCodes()}
						{assign var=identificationCodes value=$identificationCodes->toArray()}
						{assign var=publicationDates value=$publicationFormat->getPublicationDates()}
						{assign var=publicationDates value=$publicationDates->toArray()}
						{assign var=hasPubId value=false}
						{foreach from=$pubIdPlugins item=pubIdPlugin}
							{assign var=pubIdType value=$pubIdPlugin->getPubIdType()}
							{if $publicationFormat->getStoredPubId($pubIdType)}
								{assign var=hasPubId value=true}
								{break}
							{/if}
						{/foreach}

						{* Skip if we don't have any information to print about this pub format *}
						{if !$identificationCodes && !$publicationDates && !$hasPubId && !$publicationFormat->getPhysicalFormat()}
							{continue}
						{/if}

						<div class="item publication_format">

							{* Only add the format-specific heading if multiple publication formats exist *}
							{if count($publicationFormats) > 1}
								<h2 class="pkp_screen_reader">
									{assign var=publicationFormatName value=$publicationFormat->getLocalizedName()}
									{translate key="monograph.publicationFormatDetails" format=$publicationFormatName|escape}
								</h2>

								<div class="sub_item item_heading format">
									<div class="label">
										{$publicationFormat->getLocalizedName()|escape}
									</div>
								</div>
							{else}
								<h2 class="pkp_screen_reader">
									{translate key="monograph.miscellaneousDetails"}
								</h2>
							{/if}


							{* DOI's and other identification codes *}
							{if $identificationCodes}
								{foreach from=$identificationCodes item=identificationCode}
									<div class="sub_item identification_code">
										<h3 class="label">
											{$identificationCode->getNameForONIXCode()|escape}
										</h3>
										<div class="value">
											{$identificationCode->getValue()|escape}
										</div>
									</div>
								{/foreach}
							{/if}

							{* Dates of publication *}
							{if $publicationDates}
								{foreach from=$publicationDates item=publicationDate}
									<div class="sub_item date">
										<h3 class="label">
											{$publicationDate->getNameForONIXCode()|escape}
										</h3>
										<div class="value">
											{assign var=dates value=$publicationDate->getReadableDates()}
											{* note: these dates have dateFormatShort applied to them in getReadableDates() if they need it *}
											{if $publicationDate->isFreeText() || $dates|@count == 1}
												{$dates[0]|escape}
											{else}
												{* @todo the &mdash; ought to be translateable *}
												{$dates[0]|escape}&mdash;{$dates[1]|escape}
											{/if}
											{if $publicationDate->isHijriCalendar()}
												<div class="hijri">
													{translate key="common.dateHijri"}
												</div>
											{/if}
										</div>
									</div>
								{/foreach}
							{/if}

							{* PubIDs *}
							{foreach from=$pubIdPlugins item=pubIdPlugin}
								{assign var=pubIdType value=$pubIdPlugin->getPubIdType()}
								{assign var=storedPubId value=$publicationFormat->getStoredPubId($pubIdType)}
								{if $storedPubId != ''}
									<div class="sub_item pubid {$publicationFormat->getId()|escape}">
										<h2 class="label">
											{$pubIdType}
										</h2>
										<div class="value">
											{$storedPubId|escape}
										</div>
									</div>
								{/if}
							{/foreach}

							{* Physical dimensions *}
							{if $publicationFormat->getPhysicalFormat()}
								<div class="sub_item dimensions">
									<h2 class="label">
										{translate key="monograph.publicationFormat.productDimensions"}
									</h2>
									<div class="value">
										{$publicationFormat->getDimensions()|escape}
									</div>
								</div>
							{/if}
						</div>
					{/if}
				{/foreach}
			{/if}

			{call_hook name="Templates::Catalog::Book::Details"}
			
		</div><!-- .details -->
	</div><!-- .row -->

</div><!-- .obj_monograph_full -->