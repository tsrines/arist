module Api
  class DevicesController < ApplicationController
    def register
      phone = Phonelib.parse(params[:phone_number]).e164
      device = Device.create!(phone_number: phone, carrier: params[:carrier])
      render json: device.id, status: :created
    end

    def alive
      device = Device.find(params[:device_id])
      unless device.disabled_at
        heartbeat = Heartbeat.create!(heartbeat_params)
        render json: {}, status: :created
      else
        render_json_error(:unauthorized, 'Device has been disabled')
      end
    end

    def report
      device = Device.find(params[:device_id])
      unless device.disabled_at
        report = Report.create!(report_params)
        render json: {}, status: :created
      else
        render_json_error(:unauthorized, 'Device has been disabled')
      end
    end

    def terminate
      device = Device.find(params[:device_id])
      unless device.disabled_at
        device.update(disabled_at: Time.now)
        render json: {}, status: 201
      else
        render_json_error(:unauthorized, 'Device has been disabled')
      end
    end

    def not_found
      render json: { error: 'Page not found' }, status: 500
    end

    private

    def heartbeat_params
      params.permit(:device_id)
    end

    def device_params
      params.permit(:carrier, :phone_number)
    end

    def report_params
      params.permit(:message, :sender, :device_id)
    end
  end
end
