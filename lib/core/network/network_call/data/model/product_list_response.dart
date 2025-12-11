class ProductListResponse {
  bool? error;
  ProductListData? data;
  String? message;

  ProductListResponse({this.error, this.data, this.message});

  ProductListResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? ProductListData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class ProductListData {
  int? currentPage;
  List<ProductData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  ProductListData(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  ProductListData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(ProductData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class ProductData {
  int? id;
  String? slug;
  int? vendorId;
  int? wishlistId;
  int? productId;
  String? title;
  String? productDescription;
  String? productType;
  String? regularPrice;
  String? salePrice;
  String? sku;
  String? stockQuantity;
  String? productShortDescription;
  String? productFeaturedImage;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? stockStatus;
  String? variablePrice;
  String? inWishlist;
  int? isInWishlist;
  double? avgRating;
  List<ParentCategories>? parentCategories;
  List<ChildCategories>? childCategories;
  List<Variations>? variations;
  VendorName? vendorName;
  Metrics? metrics;
  List<SimpleGallery>? simpleGallery;
  List<AdditionalInfo>? additionalInfo;

  ProductData(
      {this.id,
        this.slug,
        this.vendorId,
        this.wishlistId,
        this.productId,
        this.title,
        this.productDescription,
        this.productType,
        this.regularPrice,
        this.salePrice,
        this.sku,
        this.stockQuantity,
        this.productShortDescription,
        this.productFeaturedImage,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.variablePrice,
        this.stockStatus,
        this.inWishlist,
        this.isInWishlist,
        this.avgRating,
        this.parentCategories,
        this.childCategories,
        this.variations,
        this.metrics,
        this.vendorName});

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    vendorId = json['vendor_id'];
    wishlistId = json['wishlist_id'];
    productId = json['product_id'];
    title = json['title'];
    productDescription = json['product_description'];
    productType = json['product_type'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    sku = json['sku'];
    stockQuantity = json['stock_quantity'];
    productShortDescription = json['product_short_description'];
    productFeaturedImage = json['product_featured_image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    stockStatus = json['stock_status'];
    inWishlist = json['in_wishlist'];
    isInWishlist = json['is_in_wishlist'];
    variablePrice = json['variable_price'];
    avgRating = _parseDouble(json['avg_rating']); // Use _parseDouble for null safety
    if (json['parent_categories'] != null) {
      parentCategories = <ParentCategories>[];
      json['parent_categories'].forEach((v) {
        parentCategories!.add(ParentCategories.fromJson(v));
      });
    }
    if (json['child_categories'] != null) {
      childCategories = <ChildCategories>[];
      json['child_categories'].forEach((v) {
        childCategories!.add(ChildCategories.fromJson(v));
      });
    }
    if (json['variations'] != null) {
      variations = <Variations>[];
      json['variations'].forEach((v) {
        variations!.add(Variations.fromJson(v));
      });
    }
    vendorName = json['vendor_name'] != null
        ? VendorName.fromJson(json['vendor_name'])
        : null;
    if (json['simple_gallery'] != null) {
      simpleGallery = <SimpleGallery>[];
      json['simple_gallery'].forEach((v) {
        simpleGallery!.add(SimpleGallery.fromJson(v));
      });
    }
    if (json['additional_info'] != null) {
      additionalInfo = <AdditionalInfo>[];
      json['additional_info'].forEach((v) {
        additionalInfo!.add(AdditionalInfo.fromJson(v));
      });
    }
    metrics =
    json['metrics'] != null ? new Metrics.fromJson(json['metrics']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wishlist_id'] = wishlistId;
    data['product_id'] = productId;
    data['id'] = id;
    data['slug'] = slug;
    data['vendor_id'] = vendorId;
    data['title'] = title;
    data['product_description'] = productDescription;
    data['product_type'] = productType;
    data['regular_price'] = regularPrice;
    data['sale_price'] = salePrice;
    data['sku'] = sku;
    data['stock_quantity'] = stockQuantity;
    data['product_short_description'] = productShortDescription;
    data['product_featured_image'] = productFeaturedImage;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['stock_status'] = stockStatus;
    data['variable_price'] = variablePrice;
    data['in_wishlist'] = inWishlist;
    data['is_in_wishlist'] = this.isInWishlist;
    data['avg_rating'] = avgRating; // Will be null if not set
    if (parentCategories != null) {
      data['parent_categories'] =
          parentCategories!.map((v) => v.toJson()).toList();
    }
    if (childCategories != null) {
      data['child_categories'] =
          childCategories!.map((v) => v.toJson()).toList();
    }
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    if (vendorName != null) {
      data['vendor_name'] = vendorName!.toJson();
    }
    if (simpleGallery != null) {
      data['simple_gallery'] =
          simpleGallery!.map((v) => v.toJson()).toList();
    }
    if (additionalInfo != null) {
      data['additional_info'] =
          additionalInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value; // Handle double values directly
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
    return null; // Fallback to null for invalid cases
  }
}

class SimpleGallery {
  int? id;
  String? productId;
  String? imagePath;
  String? createdAt;
  String? updatedAt;

  SimpleGallery(
      {this.id,
        this.productId,
        this.imagePath,
        this.createdAt,
        this.updatedAt});

  SimpleGallery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['image_path'] = imagePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Metrics {
  int? id;
  int? productId;
  int? salesCount;
  int? viewsCount;
  String? createdAt;
  String? updatedAt;

  Metrics(
      {this.id,
        this.productId,
        this.salesCount,
        this.viewsCount,
        this.createdAt,
        this.updatedAt});

  Metrics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    salesCount = json['sales_count'];
    viewsCount = json['views_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['sales_count'] = this.salesCount;
    data['views_count'] = this.viewsCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class AdditionalInfo {
  int? id;
  String? productId;
  String? name;
  String? value;
  String? createdAt;
  String? updatedAt;

  AdditionalInfo(
      {this.id,
        this.productId,
        this.name,
        this.value,
        this.createdAt,
        this.updatedAt});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    name = json['name'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['name'] = name;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Variations {
  int? id;
  String? vendorId;
  String? productId;
  String? variationName;
  String? variationSku;
  String? variationQuantity;
  String? variationRegularPrice;
  String? variationSalePrice;
  String? createdAt;
  String? updatedAt;

  Variations(
      {this.id,
        this.vendorId,
        this.productId,
        this.variationName,
        this.variationSku,
        this.variationQuantity,
        this.variationRegularPrice,
        this.variationSalePrice,
        this.createdAt,
        this.updatedAt});

  Variations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    productId = json['product_id'];
    variationName = json['variation_name'];
    variationSku = json['variation_sku'];
    variationQuantity = json['variation_quantity'];
    variationRegularPrice = json['variation_regular_price'];
    variationSalePrice = json['variation_sale_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['product_id'] = productId;
    data['variation_name'] = variationName;
    data['variation_sku'] = variationSku;
    data['variation_quantity'] = variationQuantity;
    data['variation_regular_price'] = variationRegularPrice;
    data['variation_sale_price'] = variationSalePrice;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ParentCategories {
  int? id;
  String? name;
  String? imagePath;
  String? createdAt;
  String? updatedAt;
  PivotParentCategory? pivot;

  ParentCategories(
      {this.id,
        this.name,
        this.imagePath,
        this.createdAt,
        this.updatedAt,
        this.pivot});

  ParentCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? PivotParentCategory.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image_path'] = imagePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class ChildCategories {
  int? id;
  String? name;
  String? imagePath;
  String? createdAt;
  String? updatedAt;
  PivotChildCategory? pivot;

  ChildCategories(
      {this.id,
        this.name,
        this.imagePath,
        this.createdAt,
        this.updatedAt,
        this.pivot});

  ChildCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? PivotChildCategory.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image_path'] = imagePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class PivotParentCategory {
  int? productId;
  int? parentCategoryId;

  PivotParentCategory({this.productId, this.parentCategoryId});

  PivotParentCategory.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    parentCategoryId = json['parent_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['parent_category_id'] = parentCategoryId;
    return data;
  }
}

class PivotChildCategory {
  int? productId;
  int? childCategoryId;

  PivotChildCategory({this.productId, this.childCategoryId});

  PivotChildCategory.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    childCategoryId = json['child_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['child_category_id'] = childCategoryId;
    return data;
  }
}

class VendorName {
  int? id;
  String? contactName;
  String? email;
  String? mobile;
  String? companyName;
  String? companyEmail;
  String? companyMobile;
  String? address;
  String? area;
  String? emirate;
  String? iso;
  String? trnNo;
  String? buildingNo;
  String? city;
  String? websiteAddress;
  String? establishmentYear;
  String? whatsAppNumber;
  String? street;
  String? country;
  String? poBox;
  String? fax;
  String? googleMapUrl;
  String? companyDescription;
  String? companyLogo;
  String? tradeLicense;
  String? expiryDate;
  String? vandorEmail;
  String? vandorPass;
  String? isApproved;
  String? status;
  String? createdAt;
  String? updatedAt;

  VendorName(
      {this.id,
        this.contactName,
        this.email,
        this.mobile,
        this.companyName,
        this.companyEmail,
        this.companyMobile,
        this.address,
        this.area,
        this.emirate,
        this.iso,
        this.trnNo,
        this.buildingNo,
        this.city,
        this.websiteAddress,
        this.establishmentYear,
        this.whatsAppNumber,
        this.street,
        this.country,
        this.poBox,
        this.fax,
        this.googleMapUrl,
        this.companyDescription,
        this.companyLogo,
        this.tradeLicense,
        this.expiryDate,
        this.vandorEmail,
        this.vandorPass,
        this.isApproved,
        this.status,
        this.createdAt,
        this.updatedAt});

  VendorName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contactName = json['contact_name'];
    email = json['email'];
    mobile = json['mobile'];
    companyName = json['company_name'];
    companyEmail = json['company_email'];
    companyMobile = json['company_mobile'];
    address = json['address'];
    area = json['area'];
    emirate = json['emirate'];
    iso = json['iso'];
    trnNo = json['trn_no'];
    buildingNo = json['building_no'];
    city = json['city'];
    websiteAddress = json['website_address'];
    establishmentYear = json['establishment_year'];
    whatsAppNumber = json['whatsApp_number'];
    street = json['street'];
    country = json['country'];
    poBox = json['po_box'];
    fax = json['fax'];
    googleMapUrl = json['google_map_url'];
    companyDescription = json['company_description'];
    companyLogo = json['companyLogo'];
    tradeLicense = json['tradeLicense'];
    expiryDate = json['expiry_date'];
    vandorEmail = json['vandor_email'];
    vandorPass = json['vandor_pass'];
    isApproved = json['is_approved'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['contact_name'] = contactName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['company_name'] = companyName;
    data['company_email'] = companyEmail;
    data['company_mobile'] = companyMobile;
    data['address'] = address;
    data['area'] = area;
    data['emirate'] = emirate;
    data['iso'] = iso;
    data['trn_no'] = trnNo;
    data['building_no'] = buildingNo;
    data['city'] = city;
    data['website_address'] = websiteAddress;
    data['establishment_year'] = establishmentYear;
    data['whatsApp_number'] = whatsAppNumber;
    data['street'] = street;
    data['country'] = country;
    data['po_box'] = poBox;
    data['fax'] = fax;
    data['google_map_url'] = googleMapUrl;
    data['company_description'] = companyDescription;
    data['companyLogo'] = companyLogo;
    data['tradeLicense'] = tradeLicense;
    data['expiry_date'] = expiryDate;
    data['vandor_email'] = vandorEmail;
    data['vandor_pass'] = vandorPass;
    data['is_approved'] = isApproved;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}