# Avoid Rails auto-nesting data
ActiveSupport.on_load(:action_controller) do
  wrap_parameters format: []
end
