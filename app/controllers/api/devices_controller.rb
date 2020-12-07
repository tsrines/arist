module Api
  class DevicesController < ApplicationController
    def register
      device =
        Device.create!(
          phone_number: Phonelib.parse(params[:phone_number], 'US').e164,
          carrier: params[:carrier]
        )
      render json: device.id, status: :created
    end

    def alive
      device = Device.find(params[:device_id])
      if !device.disabled_at
        heartbeat = Heartbeat.create!(device_id: params[:device_id])
        render json: {}, status: :created
      else
        render json: { error: 'Device has been disabled' }, status: 500
      end
    end

    def report
      device = Device.find(params[:device_id])
      if !device.disabled_at
        report = Report.create!(report_params)
        render json: {}, status: :created
      else
        render json: { error: 'Device has been disabled' }, status: 500
      end
    end

    def terminate
      device = Device.find(params[:device_id])
      if (device)
        device.update(disabled_at: Time.now)
        render json: {}
      end
    end

    private

    def device_params
      params.permit(:carrier, :phone_number)
    end

    def report_params
      params.permit(:message, :sender, :device_id)
    end

    def find_device
      device = Device.find(params[:device_id])
    end
  end
end
