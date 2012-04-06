window.formatDate = (date) ->
	d = new Date(date)
	day = d.getDate()
	month = d.getMonth()
	year = d.getFullYear()
	"#{year}-#{month}-#{day}"