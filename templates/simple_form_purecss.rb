SimpleForm.setup do |config|
  config.wrappers :purecss, tag: 'div', class: 'pure-control-group', error_class: 'field_with_errors' do |b|
    b.use :html5
    b.use :placeholder

    b.use :label_input
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
  end

  config.button_class = 'pure-button'
  config.default_wrapper = :purecss
end
