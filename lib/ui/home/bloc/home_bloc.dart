import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/banner.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/data/repo/bannerRepository.dart';
import 'package:nike_ecommerce_flutter/data/repo/productRepository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerrepository bannerrepository;
  final IProductRepository productRepository;
  HomeBloc(this.bannerrepository, this.productRepository)
      : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is Homerefresh) {
        try {
          emit(HomeLoading());
          final banners = await bannerrepository.getAll();
          final latestProducts =
              await productRepository.getAll(ProductSort.latest);
          final popularProducts =
              await productRepository.getAll(ProductSort.popular);
          emit(HomeSuccess(
              banners: banners,
              products: latestProducts,
              popularProducts: popularProducts));
        } catch (error) {
          emit(HomeError(
              exception: error is AppException ? error : AppException()));
        }
      }
    });
  }
}
