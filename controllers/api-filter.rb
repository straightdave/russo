# filters for APIs
before '/api/*' do
  halt 460, "err: no header x-appkey" unless header_appkey = request.env["HTTP_X_APPKEY"]
  halt 460, "err: no header x-mac"    unless header_mac    = request.env["HTTP_X_MAC"]
  halt 460, "err: invalid service"    unless @svc = Service.find_by(appkey: header_appkey)

  if request.request_method == "POST"
    payload = request.body    # don't forget to rewind body in all 'POST' actions
  else
    payload = request.path
  end

  halt 461, "err: wrong mac"          unless header_mac == @svc.build_mac(payload)
  @now = Time.now
end