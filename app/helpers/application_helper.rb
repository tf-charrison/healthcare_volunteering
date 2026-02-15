module ApplicationHelper
    def bootstrap_flash_class(key)
    case key.to_sym
    when :notice
      "alert alert-success"
    when :alert, :error
      "alert alert-danger"
    else
      "alert alert-info"
    end
  end
end
