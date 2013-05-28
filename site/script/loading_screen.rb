require 'spin.min.js' do

class LoadingScreen
  attr_reader :element

  def initialize
    @element = $window.document.create_element('div')
    @element.class_list.add('loading-screen', 'hidden', 'transition')
    @element.id = "loading_screen#{(Time.now.to_f * 1000).to_i}"

    container = $window.document.create_element('div')
    container.class_list.add('loading-container')
    @element.append_child(container)

    text = $window.document.create_element('p')
    text.inner_text = 'Loading data...'
    container.append_child(text)

    bar = $window.document.create_element('div')
    bar.class_list.add('loading-bar')
    container.append_child(bar)
  
    add_spinner_script = $window.document.create_element('script')
    add_spinner_script.type = 'text/javascript'
    script = <<EOF
  var options = {
    lines: 8, // The number of lines to draw
    length: 0, // The length of each line
    width: 4, // The line thickness
    radius: 10, // The radius of the inner circle
    corners: 1, // Corner roundness (0..1)
    rotate: 90, // The rotation offset
    direction: 1, // 1: clockwise, -1: counterclockwise
    color: '#fff', // #rgb or #rrggbb
    speed: 1, // Rounds per second
    trail: 50, // Afterglow percentage
    shadow: false, // Whether to render a shadow
    hwaccel: false, // Whether to use hardware acceleration
    className: 'spinner', // The CSS class to assign to the spinner
    zIndex: 2e9, // The z-index (defaults to 2000000000),
    top: '10px',
    left: '10px'
  };
  var target = document.getElementById('#{@element.id}');
  var spinner = new Spinner(options).spin(target);
EOF
    add_spinner_script.inner_html = script
    $window.document.head.append_child(add_spinner_script);
  end

  def show
    @can_hide_at = Time.now + 0.25
    $window.set_timeout(0) { @element.class_list.remove('hidden') }
  end

  def hide
    return if @element.class_list.contains('hidden')

    time_left_until_hide = @can_hide_at - Time.now
    if time_left_until_hide.to_f > 0
      new_time_left = time_left_until_hide * 1000
      $window.set_timeout(new_time_left) { hide } 
      return
    end

    @element.class_list.add('hidden')
    $window.set_timeout(250) { @element.parent_node.remove_child(@element) }
  end

end # LoadingScreen

end # require