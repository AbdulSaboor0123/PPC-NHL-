/*

 :PREV_YEARS_ID :=  PCKG_ACCOUNT_INQUIRY.GET_LAST_YEARS_ID(:SET_OF_BOOK,:PARM_from_date);
  :CURRENT_YEARS_FIRST_DATE := PCKG_ACCOUNT_INQUIRY.GET_THIS_YEARS_FIRST_DATE(:SET_OF_BOOK,:PARM_from_date);
	
*/

SELECT VCC.CODE_VALUE,
       VCC.CODE_DESC,
       nvl(OPENING.OP_QTY, 0) OPEN_QTY,
       nvl(OPENING.OP_SEC_QTY, 0) OPEN_SEC_QTY,
       TRANS.INOUT,
       TRANS.TYPE,
       TRANS.MASTER_ID,
       TRANS.DOC_NUMBER,
       TRANS.REF_NO,
       TRANS.DOC_DATE,
       
       TRANS.QTY QTY,
       NVL(TRANS.SEC_QTY, 0) SEC_QTY,
       
       TRANS.INV_TRANSACTION_NO,
       TRANS.ITEM_ID,
       ITEMS_MT.ITEM_CODE,
       ITEMS_MT.ITEM_DESC,
       TRANS.DESCRIPTION,
       pri_uom.uom_tiny_desc    pri_uom,
       sec_uom.uom_tiny_desc    sec_uom,
       INV_VAL.INV_VAL_DESC,
       TRANS.SUB_INV_DESC,
       FLAG

  FROM ----------------
       ----------------
        CODE_COMBINATION_VALUES VCC--,
     --  TEMP_ITEM_CRITERIA      TIC
       ---------------
       
             &PARM_EXTENDED_FROM,
       
       ITEMS_MT,
       WIZ_UOM_MT            PRI_UOM,
       WIZ_UOM_MT            SEC_UOM,
       ITEMS_INVENTORY       II,
       wiz_inv_val_method_mt inv_val,
       WIZ_ITEM_TYPE_MT      ITEM_TYPE,
       
       (SELECT SUB_INV.qty_decimal_places,
               SUB_INV.SUB_INV_DESC,
               IBMT.SHORT_DESC            TYPE,
               1                          INOUT,
               MT.GRN_NO                  DOC_NUMBER,
               MT.grn_ref_no              REF_NO,
               DET.ITEM_ID,
               MT.GRN_ID                  MASTER_ID,
               MT.GRN_DATE                DOC_DATE,
               DET.GRN_DET_ID,
               DET.PRIMARY_ACCEPTED_QTY   QTY,
               DET.SECONDRY_ACCEPTED_QTY  SEC_QTY,
               MT.INV_TRANSACTION_NO,
               SMT.COMPANY_NAME           DESCRIPTION,
               0                          FLAG
          FROM GRN_MT              MT,
               GRN_DETAIL          DET,
               SUPPLIER_MT         SMT,
               INV_BOOKS_MT        IBMT,
               ITEMS_MT,
               WIZ_ITEM_TYPE_MT    ITEM_TYPE,
               SUB_INVENTORY_MT    SUB_INV,
               INV_ORGANIZATION_MT IOMT--,
             --  TEMP_ITEM_CRITERIA  TIC
         WHERE MT.GRN_ID = DET.GRN_ID
           AND MT.SUPPLIER_ID = SMT.SUPPLIER_ID
           AND IBMT.INV_BOOK_ID = MT.INV_BOOK_ID
           AND ITEMS_MT.ITEM_ID = DET.ITEM_ID
           AND ITEMS_MT.ITEM_TYPE_ID = ITEM_TYPE.ITEM_TYPE_ID
           AND IBMT.SUB_INV_ID = SUB_INV.SUB_INV_ID
           AND SUB_INV.INV_ORG_ID = IOMT.INV_ORG_ID
           AND IOMT.OP_SUPP_ID <> MT.SUPPLIER_ID
         &PARM_WHERE_TRANS_FIRST
        --   and TIC.ITEM_ID = DET.ITEM_ID
        
        UNION ALL
        
        SELECT SUB_INV.qty_decimal_places,
               SUB_INV.SUB_INV_DESC,
               IBMT.SHORT_DESC            TYPE,
               0                          INOUT,
               MT.ISSUE_NO                DOC_NUMBER,
               MT.issue_ref_no            REF_NO,
               DET.ITEM_ID,
               MT.ISSUE_ID                MASTER_ID,
               MT.ISSUE_DATE              DOC_DATE,
               DET.ISS_DET_ID,
               DET.PRIMARY_QTY            QTY,
               DET.SECONDARY_QTY          SEC_QTY,
               MT.INV_TRANSACTION_NO,
               VCC.CODE_DESC              DESCRIPTION,
               2                          FLAG
          FROM ISSUE_MT               MT,
               ISSUE_DETAIL           DET,
               VIEW_CODE_COMBINATIONS VCC,
               INV_BOOKS_MT           IBMT,
               ITEMS_MT,
               WIZ_ITEM_TYPE_MT       ITEM_TYPE,
               SUB_INVENTORY_MT       SUB_INV--,
             --  TEMP_ITEM_CRITERIA     TIC
         WHERE MT.ISSUE_ID = DET.ISSUE_ID
           AND MT.TRANS_TYPE = 'I'
           AND DET.cC_CODE_COMB_ID = VCC.CODE_COMBINATION_ID
           AND IBMT.INV_BOOK_ID = MT.INV_BOOK_ID
           AND ITEMS_MT.ITEM_ID = DET.ITEM_ID
           AND ITEMS_MT.ITEM_TYPE_ID = ITEM_TYPE.ITEM_TYPE_ID
           AND IBMT.SUB_INV_ID = SUB_INV.SUB_INV_ID
         &PARM_WHERE_TRANS_SECOND
          -- and TIC.ITEM_ID = DET.ITEM_ID
        
        union ALL
        
        SELECT SUB_INV.qty_decimal_places,
               SUB_INV.SUB_INV_DESC,
               IBMT.SHORT_DESC            TYPE,
               1                          INOUT,
               MT.ISSUE_NO                DOC_NUMBER,
               MT.issue_ref_no            REF_NO,
               DET.ITEM_ID,
               MT.ISSUE_ID                MASTER_ID,
               MT.ISSUE_DATE              DOC_DATE,
               DET.ISS_DET_ID,
               DET.PRIMARY_QTY            QTY,
               DET.SECONDARY_QTY          SEC_QTY,
               MT.INV_TRANSACTION_NO,
               VCC.CODE_DESC              DESCRIPTION,
               0                          FLAG
          FROM ISSUE_MT               MT,
               ISSUE_DETAIL           DET,
               VIEW_CODE_COMBINATIONS VCC,
               INV_BOOKS_MT           IBMT,
               ITEMS_MT,
               WIZ_ITEM_TYPE_MT       ITEM_TYPE,
               SUB_INVENTORY_MT       SUB_INV--,
             --  TEMP_ITEM_CRITERIA     TIC
         WHERE MT.ISSUE_ID = DET.ISSUE_ID
           AND MT.TRANS_TYPE = 'R'
           AND DET.CC_CODE_COMB_ID = VCC.CODE_COMBINATION_ID
           AND IBMT.INV_BOOK_ID = MT.INV_BOOK_ID
           AND ITEMS_MT.ITEM_ID = DET.ITEM_ID
           AND ITEMS_MT.ITEM_TYPE_ID = ITEM_TYPE.ITEM_TYPE_ID
           AND IBMT.SUB_INV_ID = SUB_INV.SUB_INV_ID
         &PARM_WHERE_TRANS_SECOND
        --   and TIC.ITEM_ID = DET.ITEM_ID
        
        UNION ALL
        
        SELECT SUB_INV.qty_decimal_places,
               SUB_INV.SUB_INV_DESC,
               IBMT.SHORT_DESC TYPE,
               0 INOUT,
               MT.DC_NO DOC_NUMBER,
               MT.dc_ref_no REF_NO,
               DET.ITEM_ID,
               MT.DC_ID MASTER_ID,
               MT.DC_DATE DOC_DATE,
               DET.DC_DET_ID,
               NVL(DET.PRIMARY_QTY, 0) QTY,
               DET.SECONDARY_QTY SEC_QTY,
               MT.INV_TRANSACTION_NO,
               CMT.COMPANY_NAME DESCRIPTION,
               2 FLAG
          FROM DC_MT              MT,
               DC_DETAIL          DET,
               INV_BOOKS_MT       IBMT,
               ITEMS_MT,
               WIZ_ITEM_TYPE_MT   ITEM_TYPE,
               CUSTOMER_MT        CMT,
               SUB_INVENTORY_MT   SUB_INV--,
              -- TEMP_ITEM_CRITERIA TIC
         WHERE MT.DC_ID = DET.DC_ID
           AND MT.INV_BOOK_ID = IBMT.INV_BOOK_ID
           AND ITEMS_MT.ITEM_ID = DET.ITEM_ID
           AND ITEMS_MT.ITEM_TYPE_ID = ITEM_TYPE.ITEM_TYPE_ID
           AND IBMT.SUB_INV_ID = SUB_INV.SUB_INV_ID
           AND CMT.CUSTOMER_ID = MT.CUSTOMER_ID
         &PARM_WHERE_DC
          -- and TIC.ITEM_ID = DET.ITEM_ID
        
        UNION ALL
        
        SELECT SUB_INV.qty_decimal_places,
               SUB_INV.SUB_INV_DESC,
               IBMT.SHORT_DESC TYPE,
               1 INOUT,
               MT.PROD_NO DOC_NUMBER,
               MT.reference_no REF_NO,
               DET.ITEM_ID,
               MT.PROD_ID MASTER_ID,
               MT.PROD_DATE DOC_DATE,
               DET.PROD_DET_ID,
               NVL(DET.QTY_PRODUCED, 0) QTY,
               DET.SEC_QTY_PROD SEC_QTY,
               MT.INV_TRANSACTION_NO,
               VCC.CODE_DESC DESCRIPTION,
               0 FLAG
          FROM PRODUCTION_MT          MT,
               PRODUCTION_DETAIL      DET,
               VIEW_CODE_COMBINATIONS VCC,
               INV_BOOKS_MT           IBMT,
               ITEMS_MT,
               WIZ_ITEM_TYPE_MT       ITEM_TYPE,
               SUB_INVENTORY_MT       SUB_INV--,
               --TEMP_ITEM_CRITERIA     TIC
         WHERE MT.PROD_ID = DET.PROD_ID
           AND IBMT.INV_BOOK_ID = MT.INV_BOOK_ID
           AND DET.LOC_CODE_COMB_ID = VCC.CODE_COMBINATION_ID
           AND ITEMS_MT.ITEM_ID = DET.ITEM_ID
           AND ITEMS_MT.ITEM_TYPE_ID = ITEM_TYPE.ITEM_TYPE_ID
           AND IBMT.SUB_INV_ID = SUB_INV.SUB_INV_ID
         &PARM_WHERE_PRODUCTION
         --  and TIC.ITEM_ID = DET.ITEM_ID
        
        UNION ALL
        
        SELECT SUB_INV.qty_decimal_places,
               SUB_INV.SUB_INV_DESC,
               IBMT.SHORT_DESC TYPE,
               0 INOUT,
               MT.RMA_NO DOC_NUMBER,
               MT.rma_ref_no REF_NO,
               DET.ITEM_ID,
               MT.RMA_OUT_ID MASTER_ID,
               MT.RMA_DATE DOC_DATE,
               DET.RMA_OUT_DET_ID,
               NVL(DET.PRI_ACCEPTED_QTY, 0) QTY,
               DET.SEC_ACCEPTED_QTY SEC_QTY,
               MT.INV_TRANSACTION_NO,
               SMT.company_name DESCRIPTION,
               2 FLAG
          FROM RMA_OUTWARD_MT         MT,
               RMA_OUTWARD_DET        DET,
               VIEW_CODE_COMBINATIONS VCC,
               INV_BOOKS_MT           IBMT,
               ITEMS_MT,
               WIZ_ITEM_TYPE_MT       ITEM_TYPE,
               SUPPLIER_MT            SMT,
               SUB_INVENTORY_MT       SUB_INV--,
             --  TEMP_ITEM_CRITERIA     TIC
         WHERE MT.RMA_OUT_ID = DET.RMA_OUT_ID
           AND DET.LOC_CODE_COMBINATION_ID = VCC.CODE_COMBINATION_ID
           AND IBMT.INV_BOOK_ID = MT.INV_BOOK_ID
           AND ITEMS_MT.ITEM_ID = DET.ITEM_ID
           AND ITEMS_MT.ITEM_TYPE_ID = ITEM_TYPE.ITEM_TYPE_ID
           AND MT.SUPPLIER_ID = SMT.SUPPLIER_ID
           AND IBMT.SUB_INV_ID = SUB_INV.SUB_INV_ID
         &PARM_WHERE_RMA_OUTWARD
       --    and TIC.ITEM_ID = DET.ITEM_ID
        
        UNION ALL
        
        SELECT SUB_INV.qty_decimal_places,
               SUB_INV.SUB_INV_DESC,
               IBMT.SHORT_DESC TYPE,
               1 INOUT,
               MT.RMA_NO DOC_NUMBER,
               MT.rma_ref_no REF_NO,
               DET.ITEM_ID,
               MT.RMA_INWARD_ID MASTER_ID,
               MT.RMA_DATE DOC_DATE,
               DET.RMA_INWARD_DET_ID,
               NVL(DET.PRI_ACCEPTED_QTY, 0) QTY,
               DET.SEC_ACCEPTED_QTY SEC_QTY,
               MT.INV_TRANSACTION_NO,
               CMT.company_name DESCRIPTION,
               0 FLAG
          FROM RMA_INWARD_MT          MT,
               RMA_INWARD_DET         DET,
               VIEW_CODE_COMBINATIONS VCC,
               INV_BOOKS_MT           IBMT,
               CUSTOMER_MT            CMT,
               ITEMS_MT,
               WIZ_ITEM_TYPE_MT       ITEM_TYPE,
               SUB_INVENTORY_MT       SUB_INV--,
              -- TEMP_ITEM_CRITERIA     TIC
         WHERE MT.RMA_INWARD_ID = DET.RMA_INWARD_ID
           AND DET.LOC_CODE_COMB_ID = VCC.CODE_COMBINATION_ID
           AND IBMT.INV_BOOK_ID = MT.INV_BOOK_ID
           AND ITEMS_MT.ITEM_ID = DET.ITEM_ID
           AND MT.CUSTOMER_ID = CMT.customer_id
           AND ITEMS_MT.ITEM_TYPE_ID = ITEM_TYPE.ITEM_TYPE_ID
           AND IBMT.SUB_INV_ID = SUB_INV.SUB_INV_ID
         &PARM_WHERE_RMA_INWARD
           --and TIC.ITEM_ID = DET.ITEM_ID
        
        UNION ALL
        
        SELECT SUB_INV.qty_decimal_places,
               SUB_INV.SUB_INV_DESC,
               IBMT.SHORT_DESC TYPE,
               0 INOUT,
               MT.TRANS_NO DOC_NUMBER,
               NULL REF_NO,
               DET.ITEM_ID,
               MT.ISS_TRANS_ID MASTER_ID,
               MT.TRANS_DATE DOC_DATE,
               DET.ISS_TRANS_DET_ID,
               NVL(DET.PIRMARY_QTY, 0) QTY,
               DET.SECONDARY_QTY SEC_QTY,
               MT.INV_TRANSACTION_NO,
               'Issued to (' || to_sub_inv.short_desc || ') ' ||
               VCC.CODE_DESC DESCRIPTION,
               1 FLAG
        
          FROM TRANS_ISSUE_MT         MT,
               TRANS_ISSUE_DETAIL     DET,
               VIEW_CODE_COMBINATIONS VCC,
               INV_BOOKS_MT           IBMT,
               ITEMS_MT,
               WIZ_ITEM_TYPE_MT       ITEM_TYPE,
               SUB_INVENTORY_MT       SUB_INV,
               SUB_INVENTORY_MT       TO_SUB_INV--,
              -- TEMP_ITEM_CRITERIA     TIC
         WHERE MT.ISS_TRANS_ID = DET.ISS_TRANS_ID
           AND DET.TO_CODE_COMB_ID = VCC.CODE_COMBINATION_ID
           AND IBMT.INV_BOOK_ID = MT.INV_BOOK_ID
           AND ITEMS_MT.ITEM_ID = DET.ITEM_ID
           AND ITEMS_MT.ITEM_TYPE_ID = ITEM_TYPE.ITEM_TYPE_ID
           AND IBMT.SUB_INV_ID = SUB_INV.SUB_INV_ID
           AND MT.TO_SUB_INV = TO_SUB_INV.SUB_INV_ID(+)
         &PARM_WHERE_TRANS_ISSUE
         ---  and TIC.ITEM_ID = DET.ITEM_ID
        
        UNION ALL
        
        SELECT SUB_INV.qty_decimal_places,
               SUB_INV.SUB_INV_DESC,
               IBMT.SHORT_DESC TYPE,
               1 INOUT,
               MT.TRANS_NO DOC_NUMBER,
               NULL REF_NO,
               ISS_DET.ITEM_ID,
               MT.RCT_TRANS_ID MASTER_ID,
               MT.RECEIPT_DATE DOC_DATE,
               DET.RCT_TRANS_DET_ID,
               NVL(DET.PRIMARY_QTY, 0) QTY,
               DET.SECONDARY_QTY SEC_QTY,
               MT.INV_TRANSACTION_NO,
               'Received from (' || frm_sub_inv.short_desc || ') ' ||
               VCC.CODE_DESC DESCRIPTION,
               1 FLAG
          FROM TRANS_RCT_MT           MT,
               TRANS_RCT_DET          DET,
               TRANS_ISSUE_DETAIL     ISS_DET,
               TRANS_ISSUE_MT         ISS_MT,
               INV_BOOKS_MT           ISS_BOOK_ID,
               VIEW_CODE_COMBINATIONS VCC,
               INV_BOOKS_MT           IBMT,
               ITEMS_MT,
               WIZ_ITEM_TYPE_MT       ITEM_TYPE,
               SUB_INVENTORY_MT       SUB_INV,
               SUB_INVENTORY_MT       FRM_SUB_INV--,
             --  TEMP_ITEM_CRITERIA     TIC
         WHERE MT.RCT_TRANS_ID = DET.RCT_TRANS_ID
           AND DET.ISS_TRANS_DET_ID = ISS_DET.ISS_TRANS_DET_ID
           AND iss_DET.FROM_CODE_COMB_ID = VCC.CODE_COMBINATION_ID
           AND IBMT.INV_BOOK_ID = MT.INV_BOOK_ID
           AND ITEMS_MT.ITEM_ID = ISS_DET.ITEM_ID
           AND ITEMS_MT.ITEM_TYPE_ID = ITEM_TYPE.ITEM_TYPE_ID
           AND IBMT.SUB_INV_ID = SUB_INV.SUB_INV_ID
           AND ISS_DET.ISS_TRANS_ID = ISS_MT.ISS_TRANS_ID
           AND ISS_MT.INV_BOOK_ID = ISS_BOOK_ID.INV_BOOK_ID
           AND ISS_BOOK_ID.SUB_INV_ID = FRM_SUB_INV.SUB_INV_ID
         &PARM_WHERE_TRANS_RCT
          -- and TIC.ITEM_ID = ISS_DET.ITEM_ID
        
        UNION ALL
        
        ----------------------
        -- 15-JUL-2K6
        -- Decided with nadeem sb.that all adjustments should allways be shown on   in_part   of items ledger with sign
        ----------------------
        SELECT SUB_INV.qty_decimal_places,
               SUB_INV.SUB_INV_DESC,
               IBMT.SHORT_DESC TYPE,
               --            DECODE(DET.PRIMARY_QTY+ABS(DET.PRIMARY_QTY),0,0,1) 
               1 INOUT,
               MT.ADJUSTMENT_NO DOC_NUMBER,
               NULL REF_NO,
               DET.ITEM_ID,
               MT.ITEM_ADJUSTMENT_ID MASTER_ID,
               MT.ADJUSTMENT_DATE DOC_DATE,
               DET.ITEM_ADJUSTMENT_DET_ID,
               (NVL(DET.PRIMARY_QTY, 0)) QTY,
               ABS(DET.SECONDARY_QTY) SEC_QTY,
               MT.INV_TRANSACTION_NO,
               VCC.CODE_DESC DESCRIPTION,
               DECODE(DET.PRIMARY_QTY + ABS(DET.PRIMARY_QTY), 0, 2, 0) FLAG
          FROM item_adjustment_mt     MT,
               item_adjustment_det    DET,
               VIEW_CODE_COMBINATIONS VCC,
               INV_BOOKS_MT           IBMT,
               ITEMS_MT,
               WIZ_ITEM_TYPE_MT       ITEM_TYPE,
               SUB_INVENTORY_MT       SUB_INV--,
            --   TEMP_ITEM_CRITERIA     TIC
         WHERE MT.ITEM_ADJUSTMENT_ID = det.item_adjustment_id
           AND DET.LOC_CODE_COMB_ID = VCC.CODE_COMBINATION_ID
           AND IBMT.INV_BOOK_ID = MT.INV_BOOK_ID
           AND ITEMS_MT.ITEM_ID = DET.ITEM_ID
           AND ITEMS_MT.ITEM_TYPE_ID = ITEM_TYPE.ITEM_TYPE_ID
           AND IBMT.SUB_INV_ID = SUB_INV.SUB_INV_ID
         &PARM_WHERE_ADJUSTMENT
          -- and TIC.ITEM_ID = DET.ITEM_ID
        
        ) TRANS,
       (SELECT ITEMS.ITEM_ID,
               PCKG_INV.GET_BALANCE_QTY(:PREV_YEARS_ID,
                                        :CURRENT_YEARS_FIRST_DATE,
                                        NULL,
                                        :SUB_INV_ID,
                                        :PARM_LOCATOR_CODE_ID,
                                        ITEMS.ITEM_ID,
                                        :parm_FROM_DATE - 1,
                                        NULL) OP_QTY,
               PCKG_INV.GET_BALANCE_SEC_QTY(:PREV_YEARS_ID,
                                            :CURRENT_YEARS_FIRST_DATE,
                                            NULL,
                                            :SUB_INV_ID,
                                            :PARM_LOCATOR_CODE_ID,
                                            ITEMS.ITEM_ID,
                                            :parm_FROM_DATE - 1,
                                            NULL) OP_SEC_QTY
        
          FROM ITEMS_MT ITEMS--, TEMP_ITEM_CRITERIA TIC
         WHERE 1 = 1 &PARM_WHERE_OPENING
          -- and TIC.ITEM_ID = ITEMS.ITEM_ID
        
        ) OPENING

 WHERE

 ITEMS_MT.ITEM_ID = TRANS.ITEM_ID(+)
 AND ITEMS_MT.ITEM_ID = OPENING.ITEM_ID(+)
 and items_mt.item_id = ii.item_id(+)
 and ii.secondary_uom = sec_uom.uom_id(+)
 AND PRI_UOM.UOM_ID = ITEMS_MT.PRIMARY_UOM
 AND ITEMS_MT.INV_VAL_ID = INV_VAL.INV_VAL_ID
 AND ITEMS_MT.ITEM_TYPE_ID = ITEM_TYPE.ITEM_TYPE_ID
 --AND vcc.CODE_COMBINATION_ID = TIC.CODE_COMBINATION_ID
 --AND TIC.ITEM_ID = ITEMS_MT.ITEM_ID 
 &PARM_WHERE_MAIN &PARM_EXTENDED_WHERE
 ORDER BY TRANS.DOC_DATE, FLAG || TRANS.INV_TRANSACTION_NO
