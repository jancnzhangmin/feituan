class Api::ProductdetailsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    product = Product.find(params[:id])
    product.pv = product.pv.to_i + 1
    product.save
    if user && user.isagent == 1
      #agentprice = Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, product.id).first.price if Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, product.id).size > 0
      agentprice = get_useragentprice(user,product.id)
    else
      agentprice = product.price
    end
    buyparam = ''
    buyparam_id = 0
    buyparamoption = []
    buyparamoptionimg = []
    if product.buyparams.size > 0
      buyparam = product.buyparams.first.name
      buyparam_id = product.buyparams.first.id
      buyparamoption = []
      product.buyparams.first.buyparamoptions.each do |f|
        param = {
            name: f.name,
            value: f.id,
            checked: false,
            price: agentprice + f.weighting,
            buyparamoptionimg: f.buyparamoptionimg.split('?')[0]
        }
        buyparamoption.push param
        buyparamoptionimg_param = {
            id:f.id,
            buyparamoptionimg: f.buyparamoptionimg.split('?')[0]
        }
        buyparamoptionimg.push buyparamoptionimg_param
      end
      #buyparamoptionimg = product.buyparams.first.buyparamoptions.first.buyparamoptionimg.split('?')[0]
      buyparamoption[0][:checked] = true

    end

    evaluate = []
    evaluates = product.evaluates.order('created_at desc')
    evaluates = product.evaluates.order('created_at desc').last(5) if product.evaluates.size > 4

    evaluates.each do |f|
      username = ''
      username = f.order.user.nickname if f.order.user.nickname.to_s.size > 0
      username = '匿名' if f.niming == 1
      headurl = ''
      headurl = f.order.user.headurl if f.order.user.headurl.to_s.size > 0
      headurl = '' if f.niming == 1

      evaluateimg = f.evaluateimgs.map{|n|n.evaluateimg.split('?')[0]}
      #evaluateimg = f.evaluateimgs.map{|n|n.evaluateimg.split('?')[0]} if f.evaluateimgs.size > 2
      param = {
          id: f.id,
          username: username,
          headurl: headurl,
          summary: f.summary,
          created_at: formattime(f.created_at),
          evaluateimg: evaluateimg
      }
      evaluate.push param
    end

    saleout = 0
    saleout = Orderdetail.where('product_id = ?', product.id).sum('number') if Orderdetail.where('product_id = ?', product.id).size > 0

    param = {
        id: product.id,
        name: product.name,
        subname: product.subname,
        barcode: product.barcode,
        content: product.content,
        cover: product.cover.split('?')[0],
        price: product.price,
        agentprice: agentprice,
        pinyin: product.pinyin,
        fullpinyin: product.fullpinyin,
        pv: product.pv,
        showparam: product.showparams.order('corder'),
        buyparam: buyparam,
        buyparam_id: buyparam_id,
        buyparamoption: buyparamoption,
        productbanner: product.productbanners.order('corder').map{|n|n.productbanner.split('?')[0]},
        evaluate: evaluate,
        evaluatecount: product.evaluates.size,
        saleout: saleout,
        buyparamoptionimg: buyparamoptionimg
    }
    return_api(param)
  end
end
