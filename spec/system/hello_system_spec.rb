require 'rails_helper'

RSpec.describe Api::DevicesController, type: :controller do
  device_id = ''
  it 'POST /register returns device ID if params are valid ' do
    post :register, params: { phone_number: '8433213491', carrier: 'Verizon' }
    device_id = response.body
    expect(response.status).to eql 201
  end

  it 'POST /alive returns empty object if params are valid' do
    post :register, params: { phone_number: '8433213491', carrier: 'Verizon' }
    expect(response.status).to eql 201
    post :alive, params: { device_id: response.body }
    expect(response.body).to eql '{}'
    expect(response.status).to eql 201
  end

  it 'POST /report returns an empty object if params are valid' do
    post :register, params: { phone_number: '8433213491', carrier: 'Verizon' }
    expect(response.status).to eql 201
    post :report,
         params: { device_id: response.body, sender: '😁', message: '🥇' }
    expect(response.body).to eql '{}'
    expect(response.status).to eql 201
  end

  it 'PUT /terminate adds timestamp to disabled_at when fields are valid' do
    post :register, params: { phone_number: '8433213491', carrier: 'Verizon' }
    expect(response.status).to eql 201
    put :terminate, params: { device_id: response.body }
    expect(response.status).to eql 200
  end

  it 'POST /register returns with an error if fields are not valid' do
    post :register, params: { phone_number: 'dfdf', carrier: 'Verizon' }
    parsed_response = JSON.parse(response.body)
    expect(parsed_response.keys).to include('error')
    expect(response.status).to eql 500
  end

  it 'POST /alive returns with an error if field are not valid' do
    post :alive, params: { phone_number: 'dfdf', carrier: 'Verizon' }
    parsed_response = JSON.parse(response.body)
    expect(parsed_response.keys).to include('error')
    expect(response.status).to eql 500
  end

  it 'POST /report returns with an error if field are not valid' do
    post :report, params: { phone_number: 'dfdf', carrier: 'Verizon' }
    parsed_response = JSON.parse(response.body)
    expect(parsed_response.keys).to include('error')
    expect(response.status).to eql 500
  end

  it 'PUT /terminate returns with an error if field are not valid' do
    put :terminate, params: { phone_number: 'dfdf', carrier: 'Verizon' }
    parsed_response = JSON.parse(response.body)
    expect(parsed_response.keys).to include('error')
    expect(response.status).to eql 500
  end

  it 'Rejects POST requests from disabled devices' do
    post :register, params: { phone_number: '8433213491', carrier: 'Verizon' }
    device_id = response.body
    expect(response.status).to eql 201
    put :terminate, params: { device_id: device_id }
    expect(response.status).to eql 200
    post :alive, params: { device_id: device_id }
    expect(response.status).to eql 500
    post :report, params: { device_id: device_id, sender: '😁', message: '🥇' }
    expect(response.status).to eql 500
  end

  it 'Converts to e164 phone numbers' do
    post :register,
         params: { phone_number: '(843) 233-1247', carrier: 'Verizon' }
    expect(Device.all.last.phone_number).to eql '+18432331247'
  end
end
