				{**************************** CITAÇÂO"!!!!!!!!!!!!!!!!! ********************************}




				<div class="item citation"> <b>COMO CITAR</b><br> {* ABNT *} <div class="sub_item abnt"> <button id="buttonabnt">ABNT</button>
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
				Disponível em: <a href="https://www.livrosabertos.sibi.usp.br/portaldelivrosUSP/catalog/book/{$monograph->getBestId()}"> https://www.livrosabertos.sibi.usp.br/portaldelivrosUSP/catalog/book/{$monograph->getBestId()}</a> .
				Acesso em {$smarty.now|date_format:"%e %B. %Y"}.
				
				
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
					 Disponível em: <a href="https://www.livrosabertos.sibi.usp.br/portaldelivrosUSP/catalog/book/{$monograph->getBestId()}"> https://www.livrosabertos.sibi.usp.br/portaldelivrosUSP/catalog/book/{$monograph->getBestId()}</a> .
					 Acesso em: {$smarty.now|date_format:"%e %b. %Y"}.
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
					[Acesso em: {$smarty.now|date_format:"%e %B. %Y"}.]
					Disponível em <a href="https://www.livrosabertos.sibi.usp.br/portaldelivrosUSP/catalog/book/{$monograph->getBestId()}"> https://www.livrosabertos.sibi.usp.br/portaldelivrosUSP/catalog/book/{$monograph->getBestId()}</a> </p>
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
				 [citado {$smarty.now|date_format:"%e de %B %Y"}].
				 DOI: <a href="{$doiUrl}">{$doiUrl}</a> 
				 Disponível em <a href="https://www.livrosabertos.sibi.usp.br/portaldelivrosUSP/catalog/book/{$monograph->getBestId()}"> https://www.livrosabertos.sibi.usp.br/portaldelivrosUSP/catalog/book/{$monograph->getBestId()}</a> 
				 
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
		</div>
				{**************************** FINAL de CITAÇÂO"!!!!!!!!!!!!!!!!! ********************************}

