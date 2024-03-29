
import UIKit
import Kingfisher

protocol ProductCellDelegate : class {
    func productFavorited(product: Product)
}

class ProductCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var productImg: RoundImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var productBrandName: UILabel!
    
    // Variables
    weak var delegate : ProductCellDelegate?
    private var product: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(product: Product, delegate: ProductCellDelegate) {
        self.product = product
        self.delegate = delegate
        
        productTitle.text = product.name
        productBrandName.text = product.burandName
        
        if let url = URL(string: product.imageUrl) {
            let placeholder = UIImage(named: AppImages.Placeholder)
            productImg.kf.indicatorType = .activity
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
            productImg.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ja_JP")
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        //contains()の引数はEquatableに準拠している必要がある
        if UserService.favorites.contains(product) {
            favoriteBtn.setImage(UIImage(named: AppImages.FilledHeart), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: AppImages.EmptyHeart), for: .normal)
        }
    }
    
    
    @IBAction func favoriteClicked(_ sender: Any) {
        delegate?.productFavorited(product: product)
    }
}
