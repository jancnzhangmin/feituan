class Api::GetopenidsController < ApplicationController
  def index
    $client ||= WeixinAuthorize::Client.new('wx9ba0afe3f3f1aa14', '92bdb66ae430c649d4ef4099fc5115f7')
    res = $client.get_oauth_access_token(params[:code])
    if res.code == 40001
      $client = WeixinAuthorize::Client.new('wx9ba0afe3f3f1aa14', '92bdb66ae430c649d4ef4099fc5115f7')
      res = $client.get_oauth_access_token(params[:code])
    end

    openid = res.result["openid"]
    user_info = $client.user(openid)
    user = User.find_by_openid(openid)
    if !user
      user = User.create(openid:openid, nickname:user_info.result["nickname"], headurl:user_info.result["headimgurl"], isagent:0, realnamestatus:0, balance:0)
      if params[:usertoken].to_s.size > 10
        parentuser = User.find_by_token(params[:usertoken])
        if parentuser && params[:usertoken] != user.token
          user.update(up_id:parentuser.id)
        end
      end
    else
      user.update(nickname:user_info.result["nickname"], headurl:user_info.result["headimgurl"])
    end
    return_api(user.token)
  end
end
