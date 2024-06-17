<script>
    $(function () {ldelim}
        $('#formBlockSettings').pkpHandler('$.pkp.controllers.form.AjaxFormHandler');
        {rdelim});
</script>

<form
        class="pkp_form"
        id="formBlockSettings"
        method="POST"
        action="{url router=$smarty.const.ROUTE_COMPONENT op="manage" category="blocks" plugin=$pluginName verb="settings" save=true}"
>
    <!-- Always add the csrf token to secure your form -->
    {csrf}

    {fbvFormArea}
        <div class="pkp_notification">
            <div class="notifyWarning">
                {translate key="Bem vindo ao plugin FORM."}
            </div>
        </div>
		{fbvFormSection title="Descrição campo01:"}
			{fbvElement type="text" id="campo01" value=$campo01}
		{/fbvFormSection}
		{fbvFormSection title="Descrição campo02:"}
			{fbvElement type="text" id="campo02" value=$campo02}
            
		{/fbvFormSection}
		{fbvFormSection title="Descrição campo03:"}
			{fbvElement type="text" id="campo03" value=$campo03}
		{/fbvFormSection}
    {/fbvFormArea}
    {fbvFormButtons submitText="common.save"}
</form>
