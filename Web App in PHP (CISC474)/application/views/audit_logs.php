<h1>Admin Panel</h1>

<a href="<?php echo $exepath; ?>users">User List</a> | <a href="<?php echo $exepath; ?>users/auditlogs">Audit Logs</a> | <a href="<?php echo $exepath; ?>users/approve">Approve Documents</a><br /><br />
<div id="example" class="k-content">
<div id="audit_grid"  style="font-size:11px;"> </div>
<script>
    $(document).ready(function() {
        $("#audit_grid").kendoGrid({
            dataSource: {
                type: "jsonp",
                serverPaging: true,
                serverSorting: true,
                pageSize: 30,
                transport: {
                    read: "<?php echo $exepath; ?>users/auditlog_service"
                },
                schema: {
		            data: function(result) {
		                  return result.Result || result;
		            },
		            total: function(result) {
		                  return result.PageSize || result.length || 0;
		            }
		        }
            },
            scrollable: false,
            sortable: true,
            pageable: {
    			pageSize: 30
  			},
            columns: [
                { field: "log_id", title: "Log ID", width: 60 },
                { field: "name", title: "User", width: 90 },
                { field: "action_name", title: "Action", width: 90 },
                { field: "action_date", title: "Date", width: 90 },
            ]
        });
    });
</script>
</div>