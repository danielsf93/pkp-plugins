## fundingBlock

omp-3.3.0-8/plugins/blocks/fundingBlock<br>

Block Plugin de Open Monograph Press 3.3.0-8 desenvolvido para o portal de livros da ABCD USP.<br>
Devido a um erro de funcionamento do plugin funding, propus esta solução, de exibição de financiadores por plugin de bloco.<br><br>

Antes, é necessário atualizar a versão do plugin funding presente no portal para: https://github.com/danielsf93/funding <br><br>

Depois de instalado, todas as funções do plugin funding funcionarão corretamente, exceto a exibição na página de publicação, que será substituido pela exibição do plugin de bloco.<br>

<br>Prints:<br><br>

![image](https://github.com/danielsf93/fundingBlock/assets/114300053/14ed1fd8-7700-48ef-8610-f1ee9c23de1c) <br><br>

<b>Funcionalidade:</b><br>
Via 'public function getFunders' as tabelas correspondentes ao plugin Funding são acessadas. O arquivo Block.tpl compila os resultados e demonstra somente nas páginas de livros que possuem financiamento. Nos casos de não possuirem financiamento, uma mensagem 'Nenhum financiador encontrado' é exibida. Há um filtro para que o plugin não interfira em outros contextos além do contexto de publicação. O arquivo 'dados_brutos.tpl' possui uma versão mais completa do código, que utilizei para testes para a versão final do plugin. O mesmo pode ser utilizado para mais investigações se necessário.

<br><br>

  
<b>Pendências:</b><br><br>
-Verificações de segurança.<br>


## fundingBlock

omp-3.3.0-8/plugins/blocks/fundingBlock<br>

Block Plugin for Open Monograph Press 3.3.0-8 developed for the ABCD USP book portal.<br>
Due to an error in the functioning of the funding plugin, I proposed this solution, showing funders per block plugin.<br><br>

First, it is necessary to update the version of the funding plugin present on the portal to: https://github.com/danielsf93/funding <br><br>

Once installed, all functions of the funding plugin will work correctly, except the display on the publish page, which will be replaced by the block plugin display.<br>

<br>Prints:<br><br>

![image](https://github.com/danielsf93/fundingBlock/assets/114300053/14ed1fd8-7700-48ef-8610-f1ee9c23de1c) <br>


