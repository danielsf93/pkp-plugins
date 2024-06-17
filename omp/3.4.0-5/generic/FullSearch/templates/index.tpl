{* plugins/generic/AbcdSearch/templates/index.tpl *}

{include file="frontend/components/header.tpl" pageTitleTranslated=$title}

<div class="page">
    <h1>{translate key="plugins.generic.fullsearch.pagetitle"}</h1>
    
    {foreach from=$obterDados item=copyrightholder key=copyrightholderName}
        <div class="copyright-holder">
            <h2>{$copyrightholderName}</h2>
            
            <button class="expand-button">{translate key="plugins.generic.fullsearch.show"}</button>
            <div class="book-list" style="display:none;">
                <ul>
                    {foreach from=$copyrightholder item=book}
                        <li>
                            <a href="{url page='catalog' op='book' path=['book'=>$book.publication_id]|cat}" target="_blank">
                                {$book.title}
                            </a>
                        </li>
                    {/foreach}
                </ul>
            </div>
            
        </div>
    {/foreach}
</div>

<style>
    .expand-button {
        font-size: 16px;
        padding: 10px 20px;
        border: none;
        background-color: #007bff;
        color: #fff;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    .expand-button:hover {
        background-color: #0056b3;
    }

    .book-list ul {
        list-style: none;
        padding: 0;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const expandButtons = document.querySelectorAll('.expand-button');
        expandButtons.forEach(button => {
            button.addEventListener('click', function() {
                const bookList = this.nextElementSibling;
                if (bookList.style.display === 'none') {
                    bookList.style.display = 'block';
                    this.innerHTML = '{translate key="plugins.generic.fullsearch.hide"}';
                } else {
                    bookList.style.display = 'none';
                    this.innerHTML = '{translate key="plugins.generic.fullsearch.show"}';
                }
            });
        });
    });
</script>

{include file="frontend/components/footer.tpl"}
