.class public final Lcom/rdx/yt/BrandCredits;
.super Ljava/lang/Object;
.source "BrandCredits.java"


# direct methods
.method public static show(Landroid/content/Context;)V
    .locals 2

    const-string v0, "RDX-YT \u2022 Developed by Abdullah Naeem Rao"

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method
