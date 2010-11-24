$ () ->
	Task = Backbone.Model.extend {
		defaults: {
			name: '',
			pseudo: false,
			complete: false,
		}

		toggleComplete: () ->
			this.save { complete: !this.get('complete') }

		remove: () ->
			this.destroy()
	}

	TaskView = Backbone.View.extend {
		tagname: 'li'

		initialize: () ->
			_.bindAll this, 'render'
			this.model.bind 'change', this.render

		events: {
			'click .delete_link': 'remove',
			'click .complete_check': 'completeToggle',
		}

		completeToggle: () ->
			this.model.toggleComplete()

		remove: () ->
			this.model.remove()
			$(this.el).html('')
			false

		render: () ->
			$(this.el).html('<input type="checkbox" class="complete_check" '+('checked' if this.model.get('complete'))+'><span class="task_title">'+this.model.get('name')+'</span> <a href="#" class="delete_link">Delete</a>')
			if this.model.get 'complete'
				this.$('.task_title').addClass 'complete'
			this
	}

	TaskList = Backbone.Collection.extend {
		model: Task,
		localStorage: new Store('tasks'),
		completed: () ->
			this.filter (task) ->
				task.get 'complete'
	}

	taskList = new TaskList()

	AppView = Backbone.View.extend {
		initialize: () ->
			_.bindAll this, 'addTask', 'addAll'
			taskList.bind 'all', this.render
			taskList.bind 'add', this.addTask
			taskList.bind 'refresh', this.addAll
			taskList.fetch()

		addTask: (task) ->
			view = new TaskView {model: task, parentView: this}
			if $('#all_list').text().trim() == 'Nothing'
				$('#all_list').html('')
			$('#all_list').append view.render().el

		addAll: () ->
			taskList.each this.addTask


		render: () ->
			if taskList.length == 0
				$('#all_list').html '<li>Nothing</li>' 
			$('#count').html (taskList.length+ ' Task')+(if taskList.length == 1 then 's' else '')
	}

	$('#new_task_submit').click(() ->
		taskList.create {
			'name': $('#new_task_name').val()
		}
		false
	)

	app = new AppView()
