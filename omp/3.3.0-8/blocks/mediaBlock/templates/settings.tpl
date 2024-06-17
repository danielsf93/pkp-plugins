<script>
    $(function () {ldelim}
        $('#mediaBlockSettings').pkpHandler('$.pkp.controllers.form.AjaxFormHandler');
        {rdelim});
</script>

<form
        class="pkp_form"
        id="mediaBlockSettings"
        method="POST"
        action="{url router=$smarty.const.ROUTE_COMPONENT op="manage" category="blocks" plugin=$pluginName verb="settings" save=true}"
>
    <!-- Always add the csrf token to secure your form -->
    {csrf}

    {fbvFormArea}
        <div class="pkp_notification">
            <div class="notifyWarning">
                <h3>{translate key="plugins.block.mediaBlock.sett"}</h3>
            </div>
        </div>
        {fbvFormSection title="plugins.block.mediaBlock.twit"}
			{fbvElement type="text" id="link01" value=$link01}
		{/fbvFormSection}
		{fbvFormSection title="plugins.block.mediaBlock.face"}
			{fbvElement type="text" id="link02" value=$link02}
            
		{/fbvFormSection}
		{fbvFormSection title="plugins.block.mediaBlock.inst"}
			{fbvElement type="text" id="link03" value=$link03}
		{/fbvFormSection}
    {/fbvFormArea}
    {fbvFormButtons submitText="common.save"}
</form>
