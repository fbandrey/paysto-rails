module Paysto
  module Controller
    extend ActiveSupport::Concern

    included do
      skip_before_filter :verify_authenticity_token, only: [:callback, :check]
    end

    def check
      invoice = Paysto.invoice_class.find_by_id(params['PAYSTO_INVOICE_ID'])
      if Paysto.invoice_valid?(invoice) && Paysto.ip_valid?(request.remote_ip) && Paysto.md5_valid?(params)
        render text: invoice.id
      else
        render text: I18n.t('paysto.check.fail')
      end
    end

    def callback
      invoice = Paysto.invoice_class.find_by_id(params['PAYSTO_INVOICE_ID'])
      if invoice && invoice.need_to_be_paid?(:paysto, params['PAYSTO_REQUEST_MODE'], params['PAYSTO_SUM']) && Paysto.ip_valid?(request.remote_ip) && Paysto.md5_valid?(params)
        invoice.notify(params, :paysto)
        invoice.send("create_#{Paysto.payment_class_name.underscore}", Paysto.get_payment_type(invoice.id), 'paysto', Paysto.real_amount(params['PAYSTO_SUM']))
        render text: invoice.id
      else
        render text: I18n.t('paysto.callback.fail')
      end
    end

    def success
      flash[:success] = I18n.t('paysto.success')
      redirect_to root_path
    end

    def fail
      flash[:alert] = I18n.t('paysto.fail')
      redirect_to root_path
    end

  end
end