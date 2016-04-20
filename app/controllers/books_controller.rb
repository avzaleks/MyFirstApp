class BooksController < ApplicationController

  before_action :signed_in_user, only: [:edit, :update, :destroy]
  # before_action :correct_user,   only: [:edit, :update, ]

  def index
    @books = Book.order('id').paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @book = Book.find(params[:id])
    @user=current_user
  end

  def new
    @genres = Genre.all
    @user = current_user
    @book=Book.new
  end

  def create
    @user=current_user
    @book = current_user.books.build(book_params)
    @book.genres << Genre.find(params[:genre]) unless params[:genre].nil?
    if @book.save
      flash[:success] = 'Thank you to add book to our library!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user=current_user
    @book=Book.find(params[:id])
    @genres = Genre.all
  end


  def update
    @user=current_user
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      flash[:success] = 'Book updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user=current_user
    Book.find(params[:id]).destroy
    flash[:success] = 'Book deleted.'
    redirect_to @user
  end


  private

  def book_params
    params.require(:book).permit(:title, :author, :image_url, :status, {:genre_ids => []})
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: 'Please sign in.'
    end
  end


  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

end


