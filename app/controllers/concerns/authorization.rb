module Authorization
  extend ActiveSupport::Concern

  included do
    class NotAuthorizedError < StandardError; end

    rescue_from NotAuthorizedError do
      redirect_to products_path, alert: t('common.not_authorized')
    end

    private
    def authorize! record = nil
      # .classify -> convierte el string en un nombre de clase valido
      # .constantize -> convierte a una constante valida
      # .send(action_name) -> 'action_name' devuelve la acción que se está realizando, y con el send es como si se hiciera '.new' o '.edit' o '.update' etc
      is_allowed = "#{controller_name.singularize}Policy".classify.constantize.new(record).send(action_name)
      raise NotAuthorizedError unless is_allowed
    end
  end
end