
  /*

  Cleaning Data in SQL Queries

  */

  Select * 
  From NashvilleHousing

  -- Standardize Date Format

  Select SaleDateConverted, CONVERT(Date, SaleDate)
  From NashvilleHousing

  Alter Table NashvilleHousing
  Add SaleDateConverted Date;

  Update NashvilleHousing
  Set SaleDateConverted = CONVERT(Date, SaleDate)

  --Populate Property Address data

  Select *
  From NashvilleHousing

  --Where PropertyAddress is null
  order by ParcelID

  Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  From NashvilleHousing a
  JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  --Updated table where null with address from owner address

  Update a 
  Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
  From NashvilleHousing a
  JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  --Breaking out Address into Individual Columns (Address, City, State)

  Select PropertyAddress 
  From NashvilleHousing
  --Where PropertyAddress is null
  --order by ParcelID

  --Seperates city and street address

  Select 
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
  ,   SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
  From NashvilleHousing

  Alter Table NashvilleHousing
  add PropertySplitAddress NVARCHAR(255);

  Update NashvilleHousing
  Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

  Alter Table NashvilleHousing
  add PropertySplitCity NVARCHAR(255);

  Update NashvilleHousing
  Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

  Select OwnerAddress
  From NashvilleHousing

  Select 
  PARSENAME(Replace(OwnerAddress, ',', '.') , 3)
  ,  PARSENAME(Replace(OwnerAddress, ',', '.') , 2)
  ,  PARSENAME(Replace(OwnerAddress, ',', '.') , 1)
  From NashvilleHousing



  -- Seperating owner address into 3 columns address, city, state 

  Alter Table NashvilleHousing
  add OwnerSplitAddress NVARCHAR(255);

  Update NashvilleHousing
  Set OwnerSplitAddress =   PARSENAME(Replace(OwnerAddress, ',', '.') , 3)

  Alter Table NashvilleHousing
  add OwnerSplitCity NVARCHAR(255);

  Update NashvilleHousing
  Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.') , 2)

  Alter Table NashvilleHousing
  add OwnerSplitState NVARCHAR(255);

  Update NashvilleHousing
  Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.') , 1)



  Select *
  From NashvilleHousing


  --Change Y and N to Yes and No for uniformity

  Select Distinct(SoldAsVacant), Count(SoldAsVacant)
  From NashvilleHousing
  Group by SoldAsVacant
  order by 2

  Select SoldAsVacant
  , Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End
  From NashvilleHousing

  Update NashvilleHousing
  Set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End
  From NashvilleHousing

  
  
  --Remove Duplicates

  WITH RowNumCTE AS(
  Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					)row_num
  From NashvilleHousing
  --order by ParcelID
  )
  Select *
  From RowNumCTE
  Where row_num > 1
  Order by PropertyAddress

  
  
  --Delete Unused Columns

  Select *
  From NashvilleHousing

  Alter Table NashvilleHousing
  Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate