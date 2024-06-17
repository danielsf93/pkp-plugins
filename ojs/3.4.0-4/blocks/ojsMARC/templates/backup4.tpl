{*/plugins/blocks/ojsMARC/templates/block.tpl*}

{if isset($publication)}

	<div class="marc">         
<hr>
{* Organizando a Informação *}

{assign var="dataFormatada" value=$smarty.now|date_format:"%Y%m%d%H%M%S.0"}

{assign var="zeroZeroCinco" value="$dataFormatada"}

{assign var="zeroZeroOito" value="230224s2020    bl            000 0 por d7 "}
        
{assign var="zeroDoisQuatro" value="a{$publication->getStoredPubId('doi')|escape}2DOI"}

{assign var="zeroQuatroZero" value="  aUSP/ABCD0 "}

{assign var="zeroQuatroUm" value="apor  "}

{assign var="zeroQuatroQuatro" value="abl1 "}

{* Obter Primeiro Autor *}
{foreach from=$publication->getData('authors') item=author name=authorLoop}
    {if $smarty.foreach.authorLoop.index == 0}
        {assign var="surname" value=$author->getLocalizedFamilyName()|escape}
        {assign var="givenName" value=$author->getLocalizedGivenName()|escape}
        {assign var="orcid" value=$author->getOrcid()|default:''}
        {assign var="affiliation" value=$author->getLocalizedAffiliation()|default:''}
        {assign var="locale" value=$author->getCountryLocalized()|escape}
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
{/foreach}

{assign var="doisQuatroCinco" value="10a{$publication->getLocalizedFullTitle()|escape}h[recurso eletrônico]  "}

{assign var=submissionPages value=$publication->getData('pages')}
{assign var="tresZeroZero" value="ap. {$submissionPages}  "}

{assign var="doisMeiaZero" value="a b{$holder}c{$publication->getData('copyrightYear')}  "}

{assign var="cincoZeroZero" value="aDisponível em: https://{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}. Acesso em: {$smarty.now|date_format:"%d.%m.%Y"}  "}

{assign var="resumoPtbr" value=$publication->getLocalizedData('abstract', 'pt_BR')}

{* Remover tags <p> e </p> *}
{assign var="resumoPtbrCleaned" value=$resumoPtbr|replace:'
':' '|replace:'<br>':'    '|replace:'<br />':'      '|replace:'<br/>':'     '|replace:'<p>':''|replace:'</p>':''|replace:'<strong>':'        '|replace:'</strong>':'         '|replace:'<sup>':'     '|replace:'</sup>':'      '|replace:'<em>':'    '|replace:'</em>':'     '}


{assign var="cincoDoisZero" value="a{$resumoPtbrCleaned}"}


{* Demais autores texto*}
{assign var="additionalAuthors" value=[]}
{foreach $authors as $index => $author}
    {if $index != 0}
        {assign var="additionalAuthors" value=array_merge($additionalAuthors, [$author])}
    {/if}
{/foreach}
{assign var="additionalAuthorsExport" value=""}
{foreach from=$publication->getData('authors') item=author name=authorLoop}
    {if $smarty.foreach.authorLoop.index > 0}
        {assign var="surname" value=$author->getLocalizedFamilyName()|escape}
        {assign var="givenName" value=$author->getLocalizedGivenName()|escape}
        {assign var="orcid" value=$author->getOrcid()|default:''}
        {if $orcid}
            {assign var="seteZeroZero" value="1 a{$surname}, {$givenName}0{$orcid}4org"}
        {else}
            {assign var="seteZeroZero" value="1 a{$surname}, {$givenName}0 4org"}
        {/if}
        {assign var="additionalAuthorsExport" value="$additionalAuthorsExport{$seteZeroZero}"}	
    {/if}
{/foreach}
   
{assign var="oitoCincoMeiaA" value="4 zClicar sobre o botão para acesso ao texto completouhttps://doi.org/{$publication->getStoredPubId('doi')|escape}3DOI "}

{assign var="ldr" value="01086nab   200277Ia 45"} 


{** CALCULO DO NUMERAL*}
{* Calculando o comprimento da variável $rec005 *}
{assign var="rec005POS" value=00}
{assign var="rec005CAR" value=sprintf('%04d', strlen($zeroZeroCinco) + 0)}
{assign var="rec005" value="005"|cat:$rec005CAR|cat:sprintf('%05d', $rec005POS)}

{* Calculando o comprimento da variável $rec008 *}
{assign var="rec008POS" value=$rec005CAR + $rec005POS}
{assign var="rec008CAR" value=sprintf('%04d', strlen($zeroZeroOito) - 3)}
{assign var="rec008" value="008"|cat:$rec008CAR|cat:sprintf('%05d', $rec008POS)}

{* Calculando o comprimento da variável $rec024 *}
{assign var="rec024POS" value=$rec008CAR + $rec008POS}
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

{* Calculando o comprimento da variável $rec242 *}
{assign var="rec242" value=''}
{assign var="rec242POS" value=$rec100CAR + $rec100POS}
{foreach from=$currentContext->getSupportedLocales() item=locale}
    {assign var="localizedTitle" value=$publication->getLocalizedTitle($locale)}
    {if $localizedTitle && $locale != $primaryLocale}
        {assign var="primaryTitle" value=$publication->getLocalizedTitle($primaryLocale)}
        {if !$primaryTitle || $localizedTitle != $primaryTitle}
            {$localizedTitles[] = $localizedTitle}
            {assign var="titleLength" value=sprintf('%04d', strlen($localizedTitle) + 5)}
            {if $smarty.foreach.current.first}
                {assign var="rec242" value="$rec242 242$titleLength"}
            {else}
                {assign var="rec242POSFormatted" value=sprintf('%05d', $rec242POS)}
                {assign var="rec242" value="$rec242 242$titleLength$rec242POSFormatted"}
            {/if}
            {assign var="rec242POS" value=$rec242POS + $titleLength}
        {/if}
    {/if}
{/foreach}

{* Calculando o comprimento da variável $rec245 *}
{if $rec242POS}
    {assign var="rec245POS" value=$rec242CAR + $rec242POS}
{else}
    {assign var="rec245POS" value=$rec100CAR + $rec100POS}
{/if}
{assign var="rec245CAR" value=sprintf('%04d', strlen($doisQuatroCinco) - 3)}
{assign var="rec245" value="245"|cat:$rec245CAR|cat:sprintf('%05d', $rec245POS)}

{assign var="rec260POS" value=$rec245CAR + $rec245POS}
{assign var="rec260CAR" value=sprintf('%04d', strlen($doisMeiaZero) + 0)}
{assign var="rec260" value="260"|cat:$rec260CAR|cat:sprintf('%05d', $rec260POS)}

{assign var="rec300POS" value=$rec260CAR + $rec260POS}
{assign var=submissionPages value=$publication->getData('pages')}
{assign var="rec300CAR" value=sprintf('%04d', strlen($submissionPages|escape) + 8)}
{assign var="rec300" value="300"|cat:$rec300CAR|cat:sprintf('%05d', $rec300POS)}

{assign var="rec500POS" value=$rec300CAR + $rec300POS}
{assign var="rec500CAR" value=sprintf('%04d', strlen($cincoZeroZero) + 0)}
{assign var="rec500" value="500"|cat:$rec500CAR|cat:sprintf('%05d', $rec500POS + 0)}

{assign var="resumoPtbr" value=$publication->getLocalizedData('abstract', 'pt_BR')}
{assign var="resumoPtbrCleaned" value=$resumoPtbr|replace:'<p>':''|replace:'</p>':''}
{assign var="rec520POS" value=$rec500CAR + $rec500POS}
{assign var="rec520CAR" value=sprintf('%04d', strlen($resumoPtbrCleaned) + 5)}
{assign var="rec520" value="520"|cat:$rec520CAR|cat:sprintf('%05d', $rec520POS)}


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


{assign var="additionalAuthorsExporter" value=""}
{assign var="rec7uuAll" value=''}
{assign var="firstAuthor" value=true}

{foreach $publication->getData('authors') as $additionalAuthor}
    {if !$firstAuthor}
        {assign var="surname" value=$additionalAuthor->getLocalizedFamilyName()|escape}
        {assign var="givenName" value=$additionalAuthor->getLocalizedGivenName()|escape}
        {assign var="orcid" value=$additionalAuthor->getOrcid()|default:''}

        {if $orcid}
            {assign var="seteZeroZero" value="1 a{$surname}, {$givenName}0{$orcid}4org"}
        {else}
            {assign var="seteZeroZero" value="1 a{$surname}, {$givenName}0 4org"}
        {/if}

        {assign var="rec7uuCAR" value=str_replace(['-', ' '], '', sprintf('%04d', strlen($seteZeroZero)))}
        {assign var="rec7uuPOS" value=sprintf('%05d', $rec520CAR + $rec520POS-0)}
        {assign var="rec7uu" value="700{$rec7uuCAR}{$rec7uuPOS}"}

        {assign var="additionalAuthorsExporter" value="$additionalAuthorsExporter{$rec7uu}"}

       
        
        {assign var="rec520POS" value=$rec7uuPOS}
        {assign var="rec520CAR" value=str_replace(['-', ' '], '', sprintf('%04d', strlen($seteZeroZero) + 0))}
        {assign var="rec7uuAll" value=$rec7uuAll|cat:$rec7uu} 
    {else}
        {assign var="firstAuthor" value=false}
    {/if}
{/foreach}

{assign var="rec7uuAll" value=str_replace(" ", "", $rec7uuAll)}



{assign var="seteSeteTres" value="0 d   h {$issue->getIssueIdentification()}, {$submissionPages|escape}, {$formattedDate} t {$currentContext->getLocalizedName()}"}
{assign var="rec773POS" value=$rec520CAR + $rec520POS + 2}  {* Valor base para POS *}
{assign var="rec773CAR" value=sprintf('%04d', max(0, strlen($seteSeteTres) + 9))}  {* Corrigir CAR com máximo 0 *}

{if $numAutoresAdicionais > 0}
    {assign var="rec773POS" value=$rec773POS + $rec773CAR}  {* Somar valor correto ao POS *}
{/if}

{assign var="rec773" value="773"|cat:$rec773CAR|cat:sprintf('%05d', max(0, $rec773POS - 2))}  {* Formatar CAR e POS corretamente *}



{assign var="rec856POS" value=$rec773CAR + $rec773POS}
{assign var="rec856CAR" value=sprintf('%04d', strlen($oitoCincoMeiaA) + 1)}
{assign var="rec856A" value="856"|cat:$rec856CAR|cat:sprintf('%05d', $rec856POS - 2)}


{assign var="rec940All" value=''}  
{assign var="rec940POS" value=$rec856CAR + $rec856POS - 5}

{foreach from=$currentContext->getSupportedLocales() item=locale}
    {assign var="localizedData" value=$publication->getLocalizedData('abstract', $locale)}
    {if $localizedData && $locale != $primaryLocale}
        {assign var="primaryAbstract" value=$publication->getLocalizedData('abstract', $primaryLocale)}
        {if !$primaryAbstract || $localizedData != $primaryAbstract}
            {assign var="noveQuatroZero" value="a{$localizedData}"}
            {assign var="rec940CAR" value=sprintf('%04d', strlen($noveQuatroZero) + 2)}  
            {assign var="rec940POSFormatted" value=sprintf('%05d', $rec940POS)}
            {assign var="rec940" value="940"|cat:$rec940CAR|cat:$rec940POSFormatted}
            {assign var="rec940All" value=$rec940All|cat:" "|cat:$rec940}
            {assign var="rec940POS" value=$rec940POS + strlen($noveQuatroZero) + 2}  
        {/if}
    {/if}
{/foreach}

{** rec945*}
{assign var="publicationDate" value=$publication->getData('datePublished')}
{assign var="publicationYear" value=date('Y', strtotime($publicationDate))}
{assign var="sectionTitle" value=$section->getLocalizedTitle()|lower|strip}
{if $sectionTitle == 'artigo' or $sectionTitle == 'artigos'}
    {assign var="noveQuatroCinco" value=" aPbARTIGO DE PERIODICOc01j{$publicationYear}lNACIONAL"}
{elseif $sectionTitle == 'resenha' or $sectionTitle == 'resenhas'}
    {assign var="noveQuatroCinco" value=" aPbARTIGO DE PERIODICO-RESENHAc03j{$publicationYear}lNACIONAL"}
{elseif $sectionTitle == 'editorial'}
    {assign var="noveQuatroCinco" value=" aPbARTIGO DE PERIODICO-CARTA/EDITORIALc33j{$publicationYear}lNACIONAL"}
{else}
    {assign var="noveQuatroCinco" value=" aPbcxxj{$publicationYear}lNACIONAL"}
{/if}
{assign var="cleaned_noveQuatroCinco" value=$noveQuatroCinco|strip}
{assign var="rec945CAR" value=sprintf('%04d', strlen($cleaned_noveQuatroCinco)+2)}
{assign var="rec945POS" value=$rec940CAR + $rec940POS}
{assign var="rec945" value="945"|cat:$rec945CAR|cat:sprintf('%05d', $rec940POS)}



 
<hr>TESTES:<br>
{assign var="authors" value=$publication->getData('authors')}
{assign var="totalAuthors" value=count($authors)}
Total de autores: {$totalAuthors}<br><br>

{assign var="titleCount" value=0}

{assign var="primaryTitle" value=$publication->getLocalizedTitle($primaryLocale)}

{foreach from=$currentContext->getSupportedLocales() item=locale}
    {if $locale != $primaryLocale}
        {assign var="localizedTitle" value=$publication->getLocalizedTitle($locale)}
        {if $localizedTitle && $localizedTitle != $primaryTitle}
            {assign var="titleCount" value=$titleCount + 1}
        {/if}
    {/if}
{/foreach}

Quantidade de títulos em outros idiomas: {$titleCount}<br><br>
{assign var="abstractCount" value=0}

{* Obter o idioma de submissão (primaryLocale) *}
{assign var="primaryLocale" value=$publication->getData('locale')}

{* Contar resumos no idioma de submissão (primário) *}
{assign var="abstractPrimary" value=$publication->getLocalizedData('abstract', $primaryLocale)}
{assign var="primaryAbstractCount" value=0}
{if $abstractPrimary}
    {assign var="primaryAbstractCount" value=1}
{/if}

{* Contar resumos em outros idiomas, sem somar o idioma de submissão *}
{assign var="otherAbstractsCount" value=0}
{assign var="localizedAbstracts" value=[]}

{foreach from=$currentContext->getSupportedLocales() item=locale}
    {assign var="localizedData" value=$publication->getLocalizedData('abstract', $locale)}
    {if $localizedData && $locale != $primaryLocale} {* Exclui o idioma de submissão *}
        {assign var="primaryAbstract" value=$publication->getLocalizedData('abstract', $primaryLocale)}
        {if !$primaryAbstract || $localizedData != $primaryAbstract}
            {append var=localizedAbstracts value=$localizedData}
            {assign var="otherAbstractsCount" value=$otherAbstractsCount + 1} {* Incrementar a contagem de outros idiomas *}
        {/if}
    {/if}
{/foreach}

Quantidade de resumos no idioma de submissão: {$primaryAbstractCount}<br>
Quantidade de resumos em outros idiomas: {$otherAbstractsCount}
<br><br>




{assign var="ldrValue" value=($totalAuthors * 12) + ($titleCount * 12) + ($primaryAbstractCount * 12) + ($otherAbstractsCount * 12) + 181}

{* Formatar como sequência de seis dígitos com zeros à esquerda *}
{assign var="ldr" value=sprintf('%05d', $ldrValue)}

LIDER: {$ldr}




					
					






<hr>TEXTO:<br>
<b>LDR= </b>{$ldr}<br>
<b>005= </b>{$zeroZeroCinco}<br>
<b>008= </b>{$zeroZeroOito}<br>
<b>024= </b>{$zeroDoisQuatro}<br>
<b>040= </b>{$zeroQuatroZero}<br>
<b>041= </b>{$zeroQuatroUm}<br>
<b>044= </b>{$zeroQuatroQuatro}<br>
<b>100= </b>{$umZeroZero}<br>


{assign var="localizedTitles" value=[]}
{foreach from=$currentContext->getSupportedLocales() item=locale}
    {assign var="localizedTitle" value=$publication->getLocalizedTitle($locale)}
    {if $localizedTitle && $locale != $primaryLocale}
        {assign var="primaryTitle" value=$publication->getLocalizedTitle($primaryLocale)}
        {if !$primaryTitle || $localizedTitle != $primaryTitle}
            {$localizedTitles[] = $localizedTitle}
         <b>242= </b>   00a{$localizedTitle}<br>
        {/if}
    {/if}
{/foreach}

{assign var="doisQuatroDois" value=''} 
{foreach from=$currentContext->getSupportedLocales() item=locale}
    {assign var="localizedTitle" value=$publication->getLocalizedTitle($locale)}
    {if $localizedTitle && $locale != $primaryLocale}
        {assign var="primaryTitle" value=$publication->getLocalizedTitle($primaryLocale)}
        {if !$primaryTitle || $localizedTitle != $primaryTitle}
            {$localizedTitles[] = $localizedTitle}
            {assign var="doisQuatroDois" value=$doisQuatroDois|cat:"00a{$localizedTitle}"}
        {/if}
    {/if}
{/foreach}





<b>245= </b>{$doisQuatroCinco}<br>
<b>260= </b>{$doisMeiaZero}<br>
{assign var=submissionPages value=$publication->getData('pages')}

<b>300= </b>{$submissionPages|escape}<br>
<b>500= </b>{$cincoZeroZero}<br>
<b>520= </b>{$publication->getLocalizedData('abstract', 'pt_BR')}   <br>
{assign var="additionalAuthorsExport" value=""}
{foreach from=$publication->getData('authors') item=author name=authorLoop}
    {if $smarty.foreach.authorLoop.index > 0}
        {assign var="surname" value=$author->getLocalizedFamilyName()|escape}
        {assign var="givenName" value=$author->getLocalizedGivenName()|escape}
        {assign var="orcid" value=$author->getOrcid()|default:''}
        {assign var="affiliation" value=$author->getLocalizedAffiliation()|default:''}
        {assign var="locale" value=$author->getCountryLocalized()|escape}
        
        {if $affiliation|strstr:'Universidade de São Paulo'}
            {assign var="seteZeroZero" value="1 a{$surname}, {$givenName}0{$orcid}5(*)7NAC"}
        {else}
            {assign var="seteZeroZero" value="1 a{$surname}, {$givenName}0{$orcid}5(*)7INT8{$affiliation}9{$locale}"}
        {/if}
        
        {assign var="additionalAuthorsExport" value="$additionalAuthorsExport{$seteZeroZero}"}	
		<b>700= </b>{$seteZeroZero}<br>
    {/if}
{/foreach}
{**Formatacao data para campo 773 *}
    {assign var="datePublished" value=$publication->getData('datePublished')}
    {assign var="timestamp" value=strtotime($datePublished)}
    {assign var="month" value=date('M', $timestamp)}
    {assign var="translatedMonth" value=""}
    {if $month == 'Jan'}{assign var="translatedMonth" value="Jan"}
    {elseif $month == 'Feb'}{assign var="translatedMonth" value="Fev."}
    {elseif $month == 'Mar'}{assign var="translatedMonth" value="Mar."}
    {elseif $month == 'Apr'}{assign var="translatedMonth" value="Abr."}
    {elseif $month == 'May'}{assign var="translatedMonth" value="Mai."}
    {elseif $month == 'Jun'}{assign var="translatedMonth" value="Jun."}
    {elseif $month == 'Jul'}{assign var="translatedMonth" value="Jul."}
    {elseif $month == 'Aug'}{assign var="translatedMonth" value="Ago."}
    {elseif $month == 'Sep'}{assign var="translatedMonth" value="Set."}
    {elseif $month == 'Oct'}{assign var="translatedMonth" value="Out."}
    {elseif $month == 'Nov'}{assign var="translatedMonth" value="Nov."}
    {elseif $month == 'Dec'}{assign var="translatedMonth" value="Dez."}
    {/if}
    {assign var="formattedDate" value=$translatedMonth|cat:' '|cat:date('Y', $timestamp)}

{assign var="seteSeteTres" value="0 d   h {$issue->getIssueIdentification()}, {$submissionPages|escape}, {$formattedDate} t {$currentContext->getLocalizedName()}"}

<b>773= </b>{$seteSeteTres}<br>

<b>856a= </b>{$oitoCincoMeiaA}<br>

{assign var="localizedAbstracts" value=[]}
{foreach from=$currentContext->getSupportedLocales() item=locale}
    {assign var="localizedData" value=$publication->getLocalizedData('abstract', $locale)}
    {if $localizedData && $locale != $primaryLocale}
        {assign var="primaryAbstract" value=$publication->getLocalizedData('abstract', $primaryLocale)}
        {if !$primaryAbstract || $localizedData != $primaryAbstract}
            <b>940= </b>a{$localizedData}  <br>
            {assign var="localizedAbstracts" value=$localizedData}
        {/if}
    {/if}
{/foreach}


{assign var="localizedAbstracts" value=[]}
{foreach from=$currentContext->getSupportedLocales() item=locale}
    {assign var="localizedData" value=$publication->getLocalizedData('abstract', $locale)}
    {if $localizedData && $locale != $primaryLocale}
        {assign var="primaryAbstract" value=$publication->getLocalizedData('abstract', $primaryLocale)}
        {if !$primaryAbstract || $localizedData != $primaryAbstract}
            {append var=localizedAbstracts value=$localizedData}
        {/if}
    {/if}
{/foreach}

{assign var="noveQuatroZero" value=""}
{foreach from=$localizedAbstracts item=abstract}
{assign var="abstractEdt" value=$abstract|replace:'
':' '|replace:'<br>':'    '|replace:'<br />':'      '|replace:'<br/>':'     '|replace:'<p>':'   '|replace:'</p>':'    '|replace:'<strong>':'        '|replace:'</strong>':'         '|replace:'<sup>':'     '|replace:'</sup>':'      '|replace:'<em>':'    '|replace:'</em>':'     '}
    {assign var="noveQuatroZero" value=$noveQuatroZero|cat:" a"|cat:$abstractEdt|cat:" "}
{/foreach}




<b>945= </b>{assign var="publicationDate" value=$publication->getData('datePublished')}
{assign var="publicationYear" value=date('Y', strtotime($publicationDate))}
{assign var="sectionTitle" value=$section->getLocalizedTitle()|lower|strip}
{if $sectionTitle == 'artigo' or $sectionTitle == 'artigos'}
{assign var="noveQuatroCinco" value=" aPbARTIGO DE PERIODICOc01j{$publicationYear}lNACIONAL"}
{elseif $sectionTitle == 'resenha' or $sectionTitle == 'resenhas'}
    {assign var="noveQuatroCinco" value=" aPbARTIGO DE PERIODICO-RESENHAc03j{$publicationYear}lNACIONAL"}
{elseif $sectionTitle == 'editorial'}
    {assign var="noveQuatroCinco" value=" aPbARTIGO DE PERIODICO-CARTA/EDITORIALc33j{$publicationYear}lNACIONAL"}
{else}
    {assign var="noveQuatroCinco" value=" aPbc j{$publicationYear}lNACIONAL"}
{/if}

{$noveQuatroCinco}<br>
<hr>





<hr>NUMERAL:<br>
a{$rec005}b
a{$rec008}b
a{$rec024}b
a{$rec040}b
a{$rec041}b
a{$rec044}b
a{$rec100}b
a{$rec242|replace:' ':''}b
{assign var="rec242EDT" value="{$rec242|replace:' ':''}"}
a{$rec245}b
a{$rec260}b
a{$rec300}b
a{$rec500}b
a{$rec520}b
a{$rec7uuAll}b
a{$rec773}b
a{$rec856A}b
a{$rec940All}b
{assign var="rec940AllEDT" value="{$rec940All|replace:' ':''}"}
a{$rec945}b

<hr>
TESTESSSS:<br>
{$rec940POS}





<hr>


{** BOTÃO*}
    <button id="downloadButton" class="botao">Baixar Registro MARC</button>
<style>
    #downloadButton { font-weight: bold; padding: 10px 20px; background-color: #076fb1; color: #ffffff; border: none; border-radius: 5px; cursor: pointer; transition: background-color 0.3s ease; }
#downloadButton:hover {
    background-color: #055a85; 
}   
</style>
{$authors=$publication->getData('authors')}
{$totalAuthors = $authors|@count}
{assign var="totalautores" value=22000193+($totalAuthors*12)}
{assign var="totalcaracteres" value=sprintf('%05d', strlen($zeroZeroCinco) + strlen($zeroZeroOito) + strlen($zeroDoisQuatro) + strlen($zeroQuatroZero) + strlen($zeroQuatroUm) + strlen($zeroQuatroQuatro) + strlen($umZeroZero) + strlen($doisQuatroCinco) + strlen($doisMeiaZero) + strlen($cincoZeroZero) + strlen($additionalAuthorsExport) + strlen($oitoCincoMeiaA) + strlen($noveQuatroCinco) + 169)}
<script>
    document.addEventListener('DOMContentLoaded', function() {
        var downloadButton = document.getElementById('downloadButton');
        downloadButton.addEventListener('click', function() {
            var text = "{$totalcaracteres}nab   2{$ldr}Ia 45  {$rec005|escape:'javascript'}{$rec008|escape:'javascript'}{$rec024|escape:'javascript'}{$rec040|escape:'javascript'}{$rec041|escape:'javascript'}{$rec044|escape:'javascript'}{$rec100|escape:'javascript'}{$rec242EDT|escape:'javascript'}{$rec245|escape:'javascript'}{$rec260|escape:'javascript'}{$rec300|escape:'javascript'}{$rec500|escape:'javascript'}{$rec520|escape:'javascript'}{$rec7uuAll|escape:'javascript'}{$rec773|escape:'javascript'}{$rec856A|escape:'javascript'}{$rec940AllEDT|escape:'javascript'}{$rec945|escape:'javascript'}{$zeroZeroCinco|escape:'javascript'}{$zeroZeroOito|escape:'javascript'}{$zeroDoisQuatro|escape:'javascript'}{$zeroQuatroZero|escape:'javascript'}{$zeroQuatroUm|escape:'javascript'}{$zeroQuatroQuatro|escape:'javascript'}{$umZeroZero|escape:'javascript'}{$doisQuatroDois|escape:'javascript'}{$doisQuatroCinco|escape:'javascript'}{$doisMeiaZero|escape:'javascript'}{$tresZeroZero|escape:'javascript'}{$cincoZeroZero|escape:'javascript'}{$cincoDoisZero|escape:'javascript'}{$additionalAuthorsExport|escape:'javascript'}{$seteSeteTres|escape:'javascript'}{$oitoCincoMeiaA|escape:'javascript'}{$noveQuatroZero|escape:'javascript'}{$noveQuatroCinco|escape:'javascript'}";
            var fileName = 'ojs.mrc'; // Nome do arquivo a ser baixado
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
{/if}