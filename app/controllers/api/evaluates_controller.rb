class Api::EvaluatesController < ApplicationController
  def index
    product = Product.find(params[:product_id])
    evaluates = product.evaluates.order('id desc')
    evaluatearr = []
    evaluates.each do |f|
      name = ''
      name = f.order.user.nickname.to_s if f.order.user.nickname.to_s.size > 0
      name = '匿名' if f.niming == 1
      face = ''
      face = f.order.user.headurl.to_s if f.order.user.headurl.to_s.size > 0
      face = '' if f.niming == 1
      param = {
          id:f.id,
          name:name,
          face:face,
          content:f.summary,
          date:formattime(f.created_at),
          imgs:f.evaluateimgs.map{|n|n.evaluateimg}
      }
      evaluatearr.push param
    end
    return_api(evaluatearr)
  end

  def create
    evaluate = Evaluate.where('order_id = ? and product_id = ?',params[:order_id], params[:product_id])
    postal = 4
    postal = params[:postal] if params[:postal] > 0
    describe = 4
    describe = params[:describe] if params[:describe] > 0
    service = 4
    service = params[:service] if params[:service] > 0
    if evaluate.size > 0
      evaluate = evaluate.first
      evaluate.update(order_id: params[:order_id], product_id:params[:product_id], postal: postal, describe:describe, service:service, summary:params[:content], niming:params[:niming])
    else
      evaluate = Evaluate.create(order_id: params[:order_id], product_id:params[:product_id], postal: postal, describe:describe, service:service, summary:params[:content], niming:params[:niming])
    end
    evaluate.evaluateimgs.destroy_all
    params[:imgs].each do |f|
      evaluate.evaluateimgs.create(evaluateimg:f[:url])
    end
    order = Order.find(params[:order_id])
    orderdetails = order.orderdetails
    productids = orderdetails.map{|n|n.product_id}
    orderdetails.each do |f|
      evaluate = order.evaluates.where('product_id = ?', f.product_id)
      if evaluate.size > 0
        productids.delete(f.product_id)
      end
    end
    if productids.size == 0
      order.evaluatestatus = 1
      order.evaluatetime = Time.now
      order.save
    end
    return_api('')
  end

end
